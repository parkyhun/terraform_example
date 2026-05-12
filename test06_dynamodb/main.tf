terraform {
  required_version = "~>1.14.0"  #github action 에서 에러나지 않게 일부 수정  
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}


resource "aws_dynamodb_table" "members" {
    name = "members"             # 테이블명 마음대로 지을수 있다
    billing_mode = "PAY_PER_REQUEST"    # 비용 지불 방식 (요청 갯수당 과금하겠다 비용미미함)
    hash_key = "num"                 # 카테고리명 마음대로 지을수 있다. (Partition key)
    #renge_key = "정령의 기준이 되는 칼럼"  # 정령이 필요하면 sort key도 추가한다
    attribute {
      name = "num"                   # 카테고리명
      type = "N"                        # 테이터 type 을 설정한다 S는 문자열 N은 숫자 
    }
    tags = {
        Name = "members TABLE"
    }
  
}