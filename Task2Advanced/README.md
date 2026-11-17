# CI/CD и удалённое хранение состояния

Автоматизация развёртывания инфраструктуры через CI/CD с **удалённым состоянием** Terraform в S3-совместимом хранилище. Состояние **не хранится локально**.


### 1. Bootstrap (один раз)

Бакет для состояния нельзя создать тем же кодом, который в нём хранит состояние. Поэтому в `bootstrap/` есть отдельная конфигурация, которую запускают **один раз** с локальным состоянием:

```bash
cd bootstrap
terraform init
terraform apply -var="cloud_id=..." -var="folder_id=..."
terraform output -raw access_key
terraform output -raw secret_key
```

Она создаёт:
- бакет Object Storage с **версионированием** (защита состояния);
- сервисный аккаунт + роль `storage.admin`;
- статический ключ доступа (S3-совместимые креды).

### 2. Инициализация remote backend

```bash
cp backend.hcl.example backend.dev.hcl
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>

terraform init -backend-config=backend.dev.hcl
```

Ключ состояния разделён по окружениям (`dev/app/terraform.tfstate`, `stage/...`, `prod/...`), состояния окружений изолированы.

### 3. Пайплайн CI/CD

Оба пайплайна реализуют один сценарий:

| Стадия     | Действие |
|------------|----------|
| `validate` | `terraform fmt -check` + `terraform validate` |
| `plan`     | `terraform plan -out=tfplan`, план сохраняется как артефакт |
| `apply`    | `terraform apply tfplan` — **только вручную / после approval**, только на `main` |

**GitHub Actions** (`.github/workflows/terraform.yml`): apply выполняется в job с `environment: production`, где настраиваются *required reviewers* это даёт кнопку подтверждения (approval) перед применением.

**GitLab CI** (`.gitlab-ci.yml`): стадия `apply` помечена `when: manual` запускается по кнопке в интерфейсе, только на ветке `main`.

## Безопасность и изоляция

- **Секреты не в коде.** `access_key`/`secret_key` передаются через `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` из секретов CI (GitHub Secrets / GitLab Masked & Protected Variables). Токен провайдера `YC_TOKEN` из секретов.
- **Состояние удалённое и версионируется**, не коммитится (см. `.gitignore`).
- **Изоляция окружений** - отдельный `key` в бакете под каждое окружение.
- **Разделение прав** - сервисный аккаунт для состояния имеет только доступ к Storage; провайдер для ресурсов аутентифицируется отдельно.
- **Apply только после approval** и только из защищённой ветки `main` - изменения в prod невозможны без ревью.
- **Блокировки состояния** - при необходимости добавляется таблица блокировок через `dynamodb_table` в backend-config.

## Запуск

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export YC_TOKEN=...

terraform init -backend-config=backend.dev.hcl
terraform plan  -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```
