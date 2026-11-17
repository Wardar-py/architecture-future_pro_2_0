variable "name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "cores" {
  description = "Количество vCPU для виртуальной машины"
  type        = number

  validation {
    condition     = var.cores >= 2 && var.cores <= 96
    error_message = "Количество ядер должно быть в диапазоне от 2 до 96."
  }
}

variable "memory" {
  description = "Объём RAM в гигабайтах"
  type        = number

  validation {
    condition     = var.memory >= 1 && var.memory <= 640
    error_message = "Объём RAM должен быть в диапазоне от 1 до 640 ГБ."
  }
}

variable "core_fraction" {
  description = "Гарантированная доля vCPU (5, 20, 50, 100). Позволяет удешевлять dev/stage."
  type        = number
  default     = 100
}

variable "boot_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Тип загрузочного диска (network-hdd, network-ssd, network-ssd-nonreplicated)"
  type        = string
  default     = "network-ssd"
}

variable "boot_image_id" {
  description = "ID образа для загрузочного диска ВМ"
  type        = string
}

variable "attached_disk" {
  description = "Параметры подключаемого (дополнительного) диска. null — диск не создаётся."
  type = object({
    size = number
    type = optional(string, "network-ssd")
  })
  default = null
}

variable "subnet_id" {
  description = "ID подсети, к которой подключается ВМ"
  type        = string
}

variable "nat" {
  description = "Выдавать ли публичный IP-адрес (NAT)"
  type        = bool
  default     = false
}

variable "ssh_user" {
  description = "Имя пользователя для SSH-доступа"
  type        = string
  default     = "ops"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
}

variable "zone" {
  description = "Зона доступности для размещения ВМ"
  type        = string
  default     = "ru-central1-a"
}

variable "preemptible" {
  description = "Прерываемая ВМ (дешевле, подходит для dev)"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Метки (labels) для ресурсов ВМ"
  type        = map(string)
  default     = {}
}
