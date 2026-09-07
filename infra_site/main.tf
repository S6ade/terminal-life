resource "yandex_compute_disk" "boot-disk" {
	name = var.terminal_life.name
	type = "network-hdd"
	zone = var.zone
	size = var.terminal_life.disk
	image_id = var.terminal_life.image_id
}

resource "yandex_vpc_network" "main_network" {
  name = "main_network"
  description = "Main network"
# Метки для фильтрации при рассширение парка ВМ
#     labels = {
# 	environment = "dev"
#     team = "platform"
#   }
}

resource "yandex_vpc_subnet" "main_subnet" {
  name = "main_subnet"
  zone = var.zone
  network_id = yandex_vpc_network.main_network.id
  v4_cidr_blocks = [var.subnet_mask]
}

resource "yandex_compute_instance" "terminal_life" {
  name = var.terminal_life.name
  platform_id = "standard-v3"
  resources {
	cores = var.terminal_life.cpu
	memory = var.terminal_life.ram
  }
  boot_disk {
	disk_id = yandex_compute_disk.boot-disk.id
  }
  network_interface {
	subnet_id = yandex_vpc_subnet.main_subnet.id
	nat = true
  }
  metadata = {
  user-data = <<-EOT
    #cloud-config
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${file("/home/s6ade/.ssh/id_ed25519.pub")}
  EOT
  }
}

resource "yandex_vpc_security_group" "web_security" {
  name = "web_security"
  network_id = yandex_vpc_network.main_network.id

  ingress {
	protocol = "TCP"
	description = "ssh_sec_port"
	v4_cidr_blocks = [ "0.0.0.0/0" ]
	port = 22
  }
    ingress {
	protocol = "TCP"
	description = "http_port"
	v4_cidr_blocks = [ "0.0.0.0/0" ]
	port = 80
  }
    ingress {
	protocol = "TCP"
	description = "https_sec_port"
	v4_cidr_blocks = [ "0.0.0.0/0" ]
	port = 443
  }
  egress {
    protocol       = "ANY"
    description    = "outgoing"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}