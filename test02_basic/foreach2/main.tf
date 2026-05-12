

# 1. 데이터 정의 (학생 명단)
locals {
    # map 을 이용
   students = {
    lee = "이영헌"
    kim = "김영헌"
    park = "박영헌"
   }
}



# 2. for_each 를 사용하여 파일 생성  local_file.student_notes 는 map type 이다
resource "local_file" "student_notes" {
    for_each = local.students                                   # for_each 에 map 대입하기
    filename = "${path.module}/student_${each.key}.txt"         # ${ecah.key} 와 ${each.value} 의 내용은 다르다 (map에 넣어주었찌 때문에)
    content = "안녕하세요! ${each.value} 학생의 실습 노트입니다."
}

output "debug" {
    description = "생성된 파일들의 전체 경로 목록"
    # 여기서 item 은 local_file.student_notes map  에 저장된 아이템 중에 하나이다
    value = [for item in local_file.student_notes : item.filename]  # item.filename은 아에팀이 가지고 있는 정보중에 하나 
}