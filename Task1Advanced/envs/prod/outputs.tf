output "app_vm_id" {
  description = "ID ВМ приложения"
  value       = module.app_vm.instance_id
}

output "app_vm_internal_ip" {
  description = "Внутренний IP ВМ приложения"
  value       = module.app_vm.internal_ip
}

output "app_vm_external_ip" {
  description = "Внешний IP ВМ приложения"
  value       = module.app_vm.external_ip
}

output "app_vm_data_disk_id" {
  description = "ID подключаемого диска"
  value       = module.app_vm.data_disk_id
}
