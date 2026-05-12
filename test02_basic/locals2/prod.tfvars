# 파일명이 terraform.tfvasrs 가 아니기 대문에 terraform 을 실행 시 default 로 읽어 들이지 않는다
# prod 는 production 의 의미 -> tlfwp qovhdyd
# plan 이나 apply 할대 -var-file="prod.tfvars" 옵션을 주어서 실행해야 한다
# EX) terraform plan -var-file="prod.tfvars"

env = "prod"
project_name = "ktcluod-v1"