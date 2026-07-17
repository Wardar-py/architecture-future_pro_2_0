output "app_vm_id" {
  description = "ID ВМ приложения"
  value       = module.app_vm.instance_id
}

output "app_vm_external_ip" {
  description = "Внешний IP ВМ приложения"
  value       = module.app_vm.external_ip
}
