terraform {
  required_version = "~>1.14.0"  #github action 에서 에러나지 않게 일부 수정  
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-lock"             # 테이블명 마음대로 지을수 있다
    billing_mode = "PAY_PER_REQUEST"    # 비용 지불 방식 (요청 갯수당 과금하겠다 비용미미함)
    hash_key = "LockID"                 # 카테고리명 마음대로 지을수 있다.
    attribute {
      name = "LockID"                   # 카테고리명
      type = "S"                        # 테이터 type 을 설정한다 S는 문자열 N은 숫자 
    }
    tags = {
        Name = "Terraform State Lock Table"
    }
  
}