locals {
  environment = "dev"
}

module "app_vm" {
  source = "../../modules/vm"

  name           = "future20-${local.environment}-app"
  cores          = 2
  memory         = 4
  core_fraction  = 20
  preemptible    = true
  boot_disk_size = 20
  boot_disk_type = "network-ssd"
  boot_image_id  = var.boot_image_id

  attached_disk = {
    size = 30
    type = "network-hdd"
  }

  subnet_id      = var.subnet_id
  nat            = true
  zone           = var.zone
  ssh_user       = "ops"
  ssh_public_key = var.ssh_public_key

  labels = {
    environment = local.environment
    project     = "future-2-0"
    managed_by  = "terraform"
  }
}
