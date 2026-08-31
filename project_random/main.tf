terraform {
    required_providers {
      random = {
            source = "hashicorp/random"
            version = "~> 3.0"
      }
    }
    }

# 발표 대상 조 명단을 list에 변수 선언해서 넣어두기
variable "teams" {
  type = list(string)
  default = [ "1조", "2조", "3조", "4조", "5조", "6조" ]
}

# 랜덤한 uuid를 6개 얻어낸다 (배열)
resource "random_uuid" "team_shuffle" {
    count = length(var.teams)
    # 실행 할대마다 새롭게 사다리를 탈수 있도록
    keepers = {
      timestamp = timestamp()
    }
}

# 발표 순서를 배열에 순서대로 넣어서 출력
output "presentation_order" {
  description = "내일 조별 발표 순서 결과"
  value = [
    for item in sort([
        for i, name in var.teeams : "${random_uuid.random_uuid.team_shuffle[i].result}::::${name}"
    ]) : split("::::", item)[1]
  ]
}