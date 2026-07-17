output "instance_id" {
  description = "ID созданной виртуальной машины"
  value       = yandex_compute_instance.this.id
}

output "instance_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.this.name
}

output "internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.this.network_interface.0.ip_address
}

output "external_ip" {
  description = "Внешний IP-адрес ВМ, если включён NAT"
  value       = try(yandex_compute_instance.this.network_interface.0.nat_ip_address, null)
}

output "fqdn" {
  description = "FQDN виртуальной машины"
  value       = yandex_compute_instance.this.fqdn
}

output "boot_disk_id" {
  description = "ID загрузочного диска"
  value       = yandex_compute_instance.this.boot_disk.0.disk_id
}

output "data_disk_id" {
  description = "ID дополнительного диска, если создан"
  value       = var.attached_disk == null ? null : yandex_compute_disk.data[0].id
}
