locals {
  environment = "stage"
}

module "app_vm" {
  source = "../../modules/vm"

  name           = "future20-${local.environment}-app"
  cores          = 4
  memory         = 8
  core_fraction  = 50
  preemptible    = false
  boot_disk_size = 40
  boot_disk_type = "network-ssd"
  boot_image_id  = var.boot_image_id

  attached_disk = {
    size = 100
    type = "network-ssd"
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
