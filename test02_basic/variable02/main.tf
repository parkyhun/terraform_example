# 여러개의 type 을 map 에 담고 싶으면 object type 을 사용하면 된다




variable "member1" {
    type = object({
        num     = number
        name    = string
        is_man  = bool
    })
    
    description = "회원 한명의 정보 입니다"
    
    default = {
        num     = 1
        name    = "kim"
        is_man  = true
    }
}

variable "bucket_config" {
    type = object({
        name = string                                   # 반드시 넣어야 하는 값
        region = optional(string, "ap-northeasr-2")     # 안 넣어도 되는값 optional(type, default 값)
        versioning = optional(bool, false)              # optional 이면서 bool type 이고 넣지 않으면 false 로 설정된다.
    })
    
    description = "bucket 기본 설정값 입니다"
    
    default = {
        name = "나의 기본 s3 bucket 입니다"                # region 과  versioing 은 생략했으면 위에서 정의한 optional 기본값이 설정된다
    }
}
# 위에서 선언한 member1, bucket_config object 안에 저장된 내용을 out을 통해서 이쁘게 출력해 보세요

output "debug01_member1" {
    value = "번호 : ${var.member1.num} , 이름 : ${var.member1.name}, 남자여부 :${var.member1.is_man}"
}

output "debug2_bucket_config" {
    value = "이름 : ${var.bucket_config.name}, 리전 : ${var.bucket_config.region}, 버저닝 : ${var.bucket_config.versioning}"
}