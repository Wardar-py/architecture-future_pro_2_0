terraform {
  required_version = ">= 1.6.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.100.0"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

variable "cloud_id" { type = string }
variable "folder_id" { type = string }
variable "zone" {
  type    = string
  default = "ru-central1-a"
}
variable "bucket_name" {
  type    = string
  default = "future20-tfstate"
}

resource "yandex_iam_service_account" "tf_state" {
  name        = "tf-state-sa"
  description = "Сервисный аккаунт для доступа Terraform к бакету состояния"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.tf_state.id}"
}

resource "yandex_iam_service_account_static_access_key" "tf_state_key" {
  service_account_id = yandex_iam_service_account.tf_state.id
  description        = "Статический ключ для доступа к бакету tfstate"
}

resource "yandex_storage_bucket" "tf_state" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.tf_state_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf_state_key.secret_key

  versioning {
    enabled = true
  }

  anonymous_access_flags {
    read = false
    list = false
  }
}

output "bucket_name" {
  value = yandex_storage_bucket.tf_state.bucket
}

output "access_key" {
  description = "Access key для backend"
  value       = yandex_iam_service_account_static_access_key.tf_state_key.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Secret key для backend"
  value       = yandex_iam_service_account_static_access_key.tf_state_key.secret_key
  sensitive   = true
}
