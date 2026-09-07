output "web_ip" {
  value = yandex_compute_instance.terminal_life.network_interface[0].nat_ip_address
  description = "Публичный IP созданной виртуальной машины"
}
output "vm_name" {
  value = yandex_compute_instance.terminal_life.name
  description = "Название ВМ"
}