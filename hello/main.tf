# terraform_example/hello/main.tf
# tf 파일은  HCL 형식의 파일 입니다.


# aws provider 설정
provider "aws" {
    region = "ap-northeast-2"
}


# 간단하게 vpc 를 하나 생성해 보기
resource "aws_vpc" "test_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true # 인스턴스에 dns 이름을 부여 하기 위해 활성화
    enable_dns_support = true
    tags = {
      Name = "terraform_test_vpc"
    }
}


# 인터넷 게이트웨이
resource "aws_internet_gateway" "igw"{
    # 어떤 vpc 에 붙여야하지?  선택에 대한 문제가 발생한다
    vpc_id = aws_vpc.test_vpc.id # test_vpc 라는 이름의 vpc 가 만들어 진다면 그 id 를 여기에 사용
    tags = {
        Name = "test_vpc_igw" # tags 에 들어가는 이름은 마음대로 지을수 있다. aws console 에 로그인하면 보인다.
    }
}
