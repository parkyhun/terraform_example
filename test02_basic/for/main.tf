
variable "user_list" {
    type = list(string)         # 문자열 목록(배열)
    default = [ "alice", "bob", "david", "scott", "json"]
}

output "debug01_user_list" {
    value = [for item in var.user_list: item]       # 배열에 저장된 item 그대로 출력 
}

output "debug01_user_list2" {
    value = [for item in var.user_list: upper(item)]    #  배열에 저장된 item을 대문자로 변환해서 출력
}

output "debug01_user_list3" {
    value = [for item in var.user_list: item if length(item) <= 4]  # 배열에 저장된 item 의 길이가 4보다 작은 값만 출력 (필터링이 가능하다)
}

# 결과 데이터를 map 형태로 얻어내기
output "debug04_user_list4" {
    value = { for name in var.user_list : name => "IAM-USER-${name}"}      # { 키 => 값 } 형태로 나오면, 중괄호 {} 사용
}

# 반복문 돌면서 index 값도 활용해 보기
output "debug05_user_list5" {
    value = [ for index, item in var.user_list : "${index+1} 번째 사용자 : ${item}"]    # for 인덱스, 값 두개를 인자로 받습니다.
}

# 복합 활용
output "debug06_user_list6" {
    value = { for index, item in var.user_list : index => item} #인덱스를 ket 값, item 을 value 값으로 가지는 map 만들기
}                                                               # 인덱스가 문자열을 변환되어서 key 값으로 지정된다.

# 여러줄의 문자열을 편하게 구성하기
output "debug07_multiline" {
    # <<- 길호를 쓰면 좌축의 공백 알아서 제거, EOF는 마음대로 정할수 있다. 끝날때만 동인한 문자열로 끝나면 된다
     value = <<-EOF
        #!/bin/bash
        dnf update -y
        dnf install -y nginx
        systemctl enable nginx
        systemctl start nginx
    EOF
}

