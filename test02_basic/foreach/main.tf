
# 1. 데이터 정의 (학생 명단)
locals {
   students = ["kim", "lee", "park"]
}

# 우리는 set 또는 map 에 들어 있는 정보를 이용해서 반복문 돌면서 여러개의 자원을 만들어야 할때 가 있다

# 2. for_each 를 사용하여 파일 생성  local_file.student_notes 는 map type 이다
resource "local_file" "student_notes" {
    # list를 set 으로 변환하여 for_each에 넣어주기
    # for_each 에 대입할수 있는 것은 set type 또는 map type 만 가능하다 (list type 은 안됨)
    for_each = toset(local.students)
    # set 를 넣어주면 ${each.key} 와 #{each.value} 가 동일하다
    # map을 넣어주면 ${each.ket} 와 ${each.value} 가 다르다
    filename = "${path.module}/student_${each.key}.txt"
    content = "안녕하세요! ${each.value} 학생의 실습 노트입니다."
}

output "debug" {
    description = "생성된 파일들의 전체 경로 목록"
    # 여기서 item 은 local_file.student_notes map  에 저장된 아이템 중에 하나이다
    value = [for item in local_file.student_notes : item.filename]  # item.filename은 아에팀이 가지고 있는 정보중에 하나 
}