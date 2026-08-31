# test08_autoscale/compute.tf

# 1. SSH 키 페어 생성 (TLS 라이브러리 활용)
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "lecture-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${path.module}/lecture-key.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0600"
}

# 2. 보안 그룹 (ASG용)
resource "aws_security_group" "asg_sg" {
  name   = "allow-ssh-http"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. 우리가 직접 만든 최신 ami 를 가져오는 필터 설정
data "aws_ami" "latest_web" {
  most_recent = true
  # 우리가 직접 만든 AMI 의 owner는 self 이다
  owners      = ["self"]
  filter {
    name   = "name"
    # packer 애서 만든 이름을 참조할수 있도록 한다
    # ami_name            = "ami-web-{{timestamp}}"
    #packer 에서 위와 같은 ami 이름을 부여 했기 때문에 아래처럼 작성
    values = ["ami-web-*"]
  }
}

# 4. ASG Launch Template ( ec2 의 설계도)
resource "aws_launch_template" "lt" {
  # 생성되는 ec2의 이름의 접두어 정의하기
  name_prefix = "lecture-asg-"
  # ami 선택 (우리가 직접 만든 ami를 선택할수도 있다)
  image_id = data.aws_ami.latest_web.id
  # 인스턴스 type
  instance_type = var.instance_type # 변수에 있는 내용을 참조
  # 생성되는 ec2가 공통으로 사용하는 보안그룹
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  # 사용할 key 이름
  key_name = aws_key_pair.kp.key_name

  # 프로비저닝 후에 실행할 user_data ( 여기서는 테스트용으로 nginx 설치 및 시작)
  user_data = base64encode(<<-EOF
        #!/bin/bash
        dnf update -y
        # stress 도구 추가 설치 
        dnf install -y stress
    EOF
  )
  # default 버전을 항상 update 하도록한다
  # ami 혹은 user_data 가 변경이 되었을때 default 버전을 변경하도록 한다
  update_default_version = true

  # 시작 템플릿을 통해 생설될 리소스에 대한 상태 태크 설정 
  tag_specifications {
    # 태크를 적용할 리소스 종류
    resource_type = "instance"
    # ASG 가 인스턴스를 생성할때 마다 이 이름을 붙여준다
    tags = { Name = "asg-instance" }
  }
}

# 5. 위의 설계도를 이용해서 실제 동작할 Auto scaling Group 정의
resource "aws_autoscaling_group" "asg" {
  name = "lecture-asg"
  # ec2가 위치할 서브넷에 등록한다
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  # 이상적인(원하는) EC2의 객수 
  desired_capacity = var.desired_capacity
  # 어떤 기준 때문에 갯수를 늘린다면 가능한 최대 갯수
  max_size = var.max_size
  # 어떤 기준 때문에 갯수를 줄인다면 가능한 최소 갯수
  min_size = var.min_size

  launch_template {
    id = aws_launch_template.lt.id
    # launch template 의 소스코드가 바뀌어서 버전번호가 올라가면 바로 감지 할수 있도록 한다.
    version = aws_launch_template.lt.latest_version
  }

  # 새 인스턴스로 교체하는 설정
  instance_refresh {
    # 돌아가면서 하나씩 교체
    strategy = "Rolling"
    preferences {
      # 교체중에 최소한 몇 % 의 인스턴스가 살아 있어야 하는지
      min_healthy_percentage = 50
      # 새 인스턴스가 뜨고 나서 다음 인스터를 교체하기 전까지 시간 (3분 정도로 설정)
      instance_warmup = 180 
    }
  }

  # 기본 5분을 기다리고 나서 동작하지만 빠른 테스트를위해 60초로 줄이기 
  default_cooldown = 60

  # ALB 의 target group arn 을 여기에 등록한다
  target_group_arns = [aws_lb_target_group.web_tg.arn]
}

# 6. ASG 에 의해 생성된 실제 인스턴스의 정보를 조회
data "aws_instances" "asg_nodes" {
  # ASG가 먼저 생성되어야 된다 
  # ASG 생성이 완료될 때까지 이 조회를 기다리도록 순서를 강제합니다.
  depends_on = [aws_autoscaling_group.asg]

  # 필터링 조건: 수많은 인스턴스 중 어떤 녀석을 골라낼지 정합니다.
  instance_tags = {
    # AWS가 ASG 소속 인스턴스에 자동으로 붙여주는 "소속 태그"를 이용합니다.
    # "이 ASG 이름(lecture-asg)을 가진 그룹에 속한 애들 다 모여!" 라는 뜻입니다.
    "aws:autoscaling:groupName" = aws_autoscaling_group.asg.name
  }

  # 상태 필터: 꺼져 있거나(stopped) 생성 중인 애들은 빼고, 
  # 지금 바로 접속해서 일할 수 있는 'running' 상태인 애들만 쏙 골라냅니다.
  instance_state_names = ["running"]
}
# 7. 조회된 인스턴스 정보 출력
output "asg_instance_ips" {
  description = "Auto Scaling Group 인스턴스들의 Public IP"
  value       = data.aws_instances.asg_nodes.public_ips
}