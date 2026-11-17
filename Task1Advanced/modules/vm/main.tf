terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

resource "yandex_compute_disk" "data" {
  count = var.attached_disk == null ? 0 : 1

  name   = "${var.name}-data"
  type   = var.attached_disk.type
  zone   = var.zone
  size   = var.attached_disk.size
  labels = var.labels
}

resource "yandex_compute_instance" "this" {
  name        = var.name
  zone        = var.zone
  platform_id = "standard-v3"
  labels      = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_image_id
      size     = var.boot_disk_size
      type     = var.boot_disk_type
    }
  }

  dynamic "secondary_disk" {
    for_each = var.attached_disk == null ? [] : [1]
    content {
      disk_id = yandex_compute_disk.data[0].id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}
