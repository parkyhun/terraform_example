# test08_autoscale/variables.tf

# 변수 정의 
variable "region" { default = "ap-northeast-2" }
variable "instance_type" { default = "t3.micro" }

# autoscaling 그룹에서 원하는 ec2의 갯수
variable "desired_capacity" { default = 2 }

# autoscaling 그룹에서 최소 ec2의 갯수 
variable "min_size" { default = 1 }

# autoscaling 그룹에서 최대 ec2의 갯수 
variable "max_size" { default = 5 }

# 첫번째 가용영역
variable "avail_zone_1" { default = "ap-northeast-2a" }
# 두번째 가용영역
variable "avail_zone_2" { default = "ap-northeast-2c" }
# 가용영역을 두개를 하는 이유는 가용성 확보를 위해서 2a, 2c 를 많이 사용한다

# ec2 의 갯수
variable "ec2_count" { default = 3 } 

# variables.tf 에 domain_name 변수 추가 
variable "domain_name" {
  default = "azastest.shop"
}