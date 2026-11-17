# Модульная инфраструктура для нескольких сред

Провайдер — [Yandex Cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest)


## Что делает модуль `vm`

Создаёт виртуальную машину с:
- заданным количеством ядер (`cores`) и объёмом RAM (`memory`);
- загрузочным диском (размер/тип/образ);
- **опциональным** подключаемым диском (`attached_disk`), который создаётся только если параметр задан;
- сетевым интерфейсом в указанной подсети (`subnet_id`), с опциональным NAT;
- SSH-ключом через `metadata`.

Внутри модуля **нет захардкоженных значений окружений** — всё передаётся через переменные.

### Параметры модуля

| Переменная        | Тип             | Обязательна | По умолчанию      | Описание |
|-------------------|-----------------|-------------|-------------------|----------|
| `name`            | string          | да          | —                 | Имя ВМ / префикс ресурсов |
| `cores`           | number          | да          | —                 | Кол-во vCPU (2–96) |
| `memory`          | number          | да          | —                 | RAM в ГБ (1–640) |
| `core_fraction`   | number          | нет         | `100`             | Гарантированная доля vCPU |
| `boot_disk_size`  | number          | нет         | `20`              | Размер загрузочного диска, ГБ |
| `boot_disk_type`  | string          | нет         | `network-ssd`     | Тип загрузочного диска |
| `boot_image_id`   | string          | да          | —                 | ID образа ОС |
| `attached_disk`   | object          | нет         | `null`            | `{ size, type }` подключаемого диска |
| `subnet_id`       | string          | да          | —                 | ID подсети |
| `nat`             | bool            | нет         | `false`           | Публичный IP |
| `ssh_user`        | string          | нет         | `ops`             | Пользователь SSH |
| `ssh_public_key`  | string          | да          | —                 | Публичный SSH-ключ |
| `zone`            | string          | нет         | `ru-central1-a`   | Зона доступности |
| `preemptible`     | bool            | нет         | `false`           | Прерываемая ВМ |
| `labels`          | map(string)     | нет         | `{}`              | Метки ресурсов |

### Выходы модуля

| Выход           | Описание |
|-----------------|----------|
| `instance_id`   | ID ВМ    |
| `instance_name` | Имя ВМ |
| `internal_ip`   | Внутренний IP |
| `external_ip`   | Внешний IP (если `nat = true`) |
| `fqdn`          | FQDN ВМ |
| `boot_disk_id`  | ID загрузочного диска |
| `data_disk_id`  | ID подключаемого диска (или `null`) |

## Различия окружений

| Параметр        | dev            | stage          | prod           |
|-----------------|----------------|----------------|----------------|
| cores           | 2              | 4              | 8              |
| memory          | 4 ГБ           | 8 ГБ           | 32 ГБ          |
| core_fraction   | 20%            | 50%            | 100%           |
| preemptible     | да             | нет            | нет            |
| boot_disk       | 20 ГБ SSD      | 40 ГБ SSD      | 60 ГБ SSD      |
| attached_disk   | 30 ГБ HDD      | 100 ГБ SSD     | 500 ГБ SSD     |
| nat             | да             | да             | нет            |

Один и тот же модуль переиспользуется во всех трёх окружениях — меняются только значения переменных.

## Как запустить

Предварительно установить [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.5) и настроить доступ к Yandex Cloud (`yc init` или переменные окружения `YC_TOKEN` / сервисный аккаунт).

Заполните значения в `envs/<env>/<env>.tfvars` (ID облака, каталога, подсети, образа и SSH-ключ).

```bash
# dev
cd envs/dev
terraform init
terraform plan  -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars

# stage
cd ../stage
terraform init
terraform apply -var-file=stage.tfvars

# prod
cd ../prod
terraform init
terraform apply -var-file=prod.tfvars
```

Удаление окружения:

```bash
terraform destroy -var-file=dev.tfvars
```
