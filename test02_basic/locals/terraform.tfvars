# 선언되어 있는 변수에 넣을 값을 여기서 결정할수 있다/
# terraform.tfvars 라는 파일의 이름은 정해진 이름이다
# terraform.tfvars 는 default 설정이다 -> terraform plan(apply) 할때 default 로 이 파일을 읽어서 동작한다

env = "dev"
project_name = "ktcloud"