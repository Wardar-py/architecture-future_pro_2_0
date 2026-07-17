module "app_vm" {
  source = "../Task1Advanced/modules/vm"

  name           = "future20-${var.environment}-app"
  cores          = var.cores
  memory         = var.memory
  boot_image_id  = var.boot_image_id
  boot_disk_size = 30

  attached_disk = {
    size = 50
    type = "network-ssd"
  }

  subnet_id      = var.subnet_id
  nat            = true
  zone           = var.zone
  ssh_public_key = var.ssh_public_key

  labels = {
    environment = var.environment
    project     = "future-2-0"
    managed_by  = "terraform"
    pipeline    = "ci-cd"
  }
}
