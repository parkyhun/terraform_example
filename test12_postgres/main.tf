
provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

# VPC 및 서브넷
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "lecture-vpc"
  }
}

# AWS RDS는 고가용성(HA) 제약 조건상 최소 2개 이상의 서로 다른 가용영역(AZ) 서브넷이 필수
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a" # 가용영역 A
  tags = {
    Name = "lecture-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c" # 가용영역 C
  tags = {
    Name = "lecture-public-c"
  }
}

# 외부에서 데이터베이스 툴(DBeaver 등)로 찌를 수 있게 문을 열어주는 인터넷 대문 개통
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "lecture-igw"
  }
}

# 모든 외부 트래픽(0.0.0.0/0)을 대문(IGW)으로 던지는 이정표(라우팅 테이블) 설정
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "lecture-public-rt"
  }
}

# 두 서브넷에 이정표를 각각 바인딩하여 외부 통신로 활성화
resource "aws_route_table_association" "public_a_association" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_c_association" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}


# RDS 전용 (보안 그룹)
resource "aws_security_group" "rds_sg" {
  name        = "lecture-rds-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.main.id

  # 인바운드 규칙: 외부 전체(0.0.0.0/0)에서 PostgreSQL 국룰 포트인 5432 접근 허용
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 실무에서는 회사 사설망 IP만 매핑하는 게 정석
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lecture-rds-sg"
  }
}


# AWS 규칙: RDS 인스턴스는 반드시 '서브넷 그룹'이라는 바구니에 서브넷들을 담아서 던져야 합니다.
resource "aws_db_subnet_group" "db_sg" {
  name       = "lecture-db-subnet-group"
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_c.id]
}

resource "aws_db_instance" "database" {
  allocated_storage      = 20               # 하드디스크 용량 (기본 20GB)
  engine                 = "postgres"       # 데이터베이스 엔진 종류
  engine_version         = "13.18"          # PostgreSQL 버전 명시
  instance_class         = "db.t3.micro"    # 프리티어 사양 사양 매핑
  db_name                = "scott_db"       # 최초 부팅 시 자동 생성할 데이터베이스 방 이름
  username               = "scott"          # 관리자 
  password               = "password123!"   # 마스터 비밀번호
  db_subnet_group_name   = aws_db_subnet_group.db_sg.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  publicly_accessible = true  # 외부망에서 이 엔드포인트를 직접 노크할 수 있도록 오픈
  skip_final_snapshot = true  # 테라폼 destroy(삭제)할 때 귀찮은 최종 백업 스냅샷 생성을 생략
}


# 접속 엔드포인트 출력
output "db_endpoint" {
  value       = aws_db_instance.database.endpoint
  description = "백엔드 앱에서 복사해서 접속해야 할 AWS RDS 최종 주소!"
}