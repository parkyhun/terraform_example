
resource "local_file" "student_notes" {
    count = 3               # 반복해서 동일한 리소스를 찍어 낼때 사용하는 속성(이 블록을 3번 실행하라)

    filename = "${path.module}/student_${count.index + 1}.txt"              # 파일명 동적으로 부여하기 (count.index 를 참조할 수 있다
    content = "안녕하세요! ${count.index + 1}번 학생의 실습 노트 입니다"         # 파일의 내용도 동적으로 부여하기
}

output "debug01" {
    value = local_file.student_notes[0].filename
}
output "debug02" {
    value = local_file.student_notes[1].filename
}
output "debug03" {
    value = local_file.student_notes[2].filename
}

output "debug_all" {
    value = local_file.student_notes[*].filename        # 모든 파일 이름 가져오기, * 는 splat 연산자 이다
}