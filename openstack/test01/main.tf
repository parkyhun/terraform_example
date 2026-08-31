# 이 파일이 정상 동작하기 위해서는 인증정보가 있어야 되는데 
# 인증정보를 얻어내는 방법은
# source admin-openrc.sh (source ~/admin-openrc.sh ) 를 실행하면 된다 

terraform {
  required_providers {
    # openstack 사용할 준비
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# openstack provider 설정
provider "openstack" {}

# ==========================================
# 1. SSH 키페어 및 파일 저장
# ==========================================
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# openstack 리소스를 이용해서 키페어를 만든다
resource "openstack_compute_keypair_v2" "tf_keypair" {
  name       = "tf-open-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# 실제 키페어의 내용을 파일로 생성하기 
resource "local_sensitive_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/open-key.pem"
  file_permission = "0600"
}

# ==========================================
# 2. 프라이빗 네트워크 및 서브넷 구성
# ==========================================
resource "openstack_networking_network_v2" "tf_network" {
  name           = "tf-private-net"
  admin_state_up = true
}


resource "openstack_networking_subnet_v2" "tf_subnet" {
  name            = "tf-private-subnet"
  network_id      = openstack_networking_network_v2.tf_network.id
  cidr            = "10.0.2.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8"]
}

# ==========================================
# 3. 라우터 생성 및 네트워크 연결 
# ==========================================
# 외부 네트워크(sharednet1)의 정보를 불러옵니다.
data "openstack_networking_network_v2" "ext_network" {
    # 미리 준비된 네트워크의 이름과 일치해야 한다
  name = "sharednet1"
}


# 라우터를 생성하고 외부 네트워크를 게이트웨이로 설정합니다.
resource "openstack_networking_router_v2" "tf_router" {
    # 생성
  name                = "tf-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_network.id
}


# 라우터에 프라이빗 서브넷(10.0.2.0/24)을 인터페이스로 연결합니다.
resource "openstack_networking_router_interface_v2" "tf_router_interface" {
  router_id = openstack_networking_router_v2.tf_router.id
  subnet_id = openstack_networking_subnet_v2.tf_subnet.id
}


# ==========================================
# 4. 인스턴스 생성
# ==========================================
resource "openstack_compute_instance_v2" "tf_instance" {
  name        = "tf-ubuntu-server"
  image_name  = "Ubuntu-22.04-LTS"
  flavor_name = "m1.small"
  # 위에서 미리 준비한 키 페어가 적용된 인스턴스를 만든다
  key_pair    = openstack_compute_keypair_v2.tf_keypair.name

    # 위에서 미리 준비한 네트워크에 인스턴스가 연결되도록 한다
  network {
    uuid = openstack_networking_network_v2.tf_network.id
  }

    # 아래의 자원이 모두 준비가 되었을때 실행되도록 depends_on 모록에 필요한 정보를 나열한다
  depends_on = [
    openstack_networking_subnet_v2.tf_subnet,
    openstack_compute_keypair_v2.tf_keypair,
    local_sensitive_file.private_key_pem
  ]
}


# ==========================================
# 5. Floating IP 할당 및 연결 (추가된 부분)
# ==========================================
# sharednet1 풀에서 Floating IP를 하나 발급받습니다.
resource "openstack_networking_floatingip_v2" "tf_fip" {
  pool = "sharednet1"
 
  # 라우터 연결이 끝난 후에 IP를 발급받도록 순서를 보장합니다.
  depends_on = [openstack_networking_router_interface_v2.tf_router_interface]
}


# 발급받은 Floating IP를 우분투 인스턴스에 연결합니다.
resource "openstack_compute_floatingip_associate_v2" "tf_fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.tf_fip.address
  instance_id = openstack_compute_instance_v2.tf_instance.id
}


# ==========================================
# 6. 결과 출력 (추가된 부분)
# ==========================================
output "instance_floating_ip" {
  description = "우분투 인스턴스에 할당된 Floating IP 주소"
  value       = openstack_networking_floatingip_v2.tf_fip.address
}


# ==========================================
# 7. PostgreSQL DB 인스턴스 생성 (Trove)
# ==========================================
# m1.small Flavor의 ID를 동적으로 가져옵니다.
data "openstack_compute_flavor_v2" "db_flavor" {
  name = "m1.small"
}


# Trove DB 인스턴스 생성
resource "openstack_db_instance_v1" "pg_instance" {
  name      = "tf-postgres-instance"
  flavor_id = data.openstack_compute_flavor_v2.db_flavor.id
  size      = 5 # DB를 구동할 볼륨 크기 지정


  # 미리 생성해둔 Datastore 정보 입력
  # 미리 생성해둔 Datastore 정보 입력
  datastore {
    type    = "postgresql"
    version = "postgresql-14"  
  }


  # 인스턴스가 연결될 프라이빗 네트워크 지정
  network {
    uuid = openstack_networking_network_v2.tf_network.id
  }


  # 지정한 DB(scott_db) 자동 생성
  database {
    name = "scott_db"
  }


  # 지정한 계정(scott) 생성 및 DB 권한 부여
  user {
    name      = "scott"
    password  = "tiger"
    databases = ["scott_db"]
  }


  depends_on = [
    openstack_networking_subnet_v2.tf_subnet
  ]
}


# ==========================================
# 8. DB 인스턴스 외부 접속용 Floating IP 할당
# ==========================================
# sharednet1 풀에서 DB 전용 Floating IP를 추가로 하나 발급받습니다.
resource "openstack_networking_floatingip_v2" "db_fip" {
  pool = "sharednet1"
  depends_on = [openstack_networking_router_interface_v2.tf_router_interface]
}


# Trove 인스턴스는 Compute(Nova) 인스턴스 ID를 직접 노출하지 않으므로,
# DB 인스턴스에 할당된 프라이빗 IP 주소를 바탕으로 Neutron Port ID를 검색합니다.
data "openstack_networking_port_v2" "db_port" {
  network_id = openstack_networking_network_v2.tf_network.id
  fixed_ip   = openstack_db_instance_v1.pg_instance.addresses[0]
 
  # DB 인스턴스가 완전히 생성된 후에 IP 조회를 수행하도록 보장
  depends_on = [openstack_db_instance_v1.pg_instance]
}


# 발급받은 DB용 Floating IP를 검색한 DB 네트워크 포트에 직접 연결합니다.
resource "openstack_networking_floatingip_associate_v2" "db_fip_associate" {
  floating_ip = openstack_networking_floatingip_v2.db_fip.address
  port_id     = data.openstack_networking_port_v2.db_port.id
}


# ==========================================
# 9. DB 접속 결과 출력
# ==========================================
output "db_floating_ip" {
  description = "PostgreSQL 외부 접속용 Floating IP 주소"
  value       = openstack_networking_floatingip_v2.db_fip.address
}
