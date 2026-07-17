# Каталог доменных событий

Каталог событий целевой архитектуры: название, контекст-источник, семантика и
минимальный контракт (ключевые поля). Все события версионируются в Schema Registry
(формат JSON Schema), совместимость backward.

## Соглашения

- **Именование:** `<Домен><ПрошедшееВремя>` (напр., `LoanContractCreated`).
- **Конверт (общие поля):** `event_id`, `event_type`, `event_version`,
  `occurred_at`, `producer`, `correlation_id`, `partition_key`.
- **PII/чувствительные данные:** не передаются в открытом виде; для аналитики обезличенные ключи.

---

## Patient Flow

### PatientRegistered
- **Источник:** Patient Flow
- **Подписчики:** BI, Billing, Notifications
- **Семантика:** создан новый пациент в системе.
- **Контракт:**
  ```json
  { "patient_id": "uuid", "registered_at": "timestamp",
    "clinic_id": "uuid", "consent_given": true }
  ```

### AppointmentScheduled
- **Источник:** Patient Flow · **Подписчики:** Clinic Operations, Notifications
- **Контракт:** `{ "appointment_id","patient_id","doctor_id","scheduled_at","clinic_id" }`

### EncounterCompleted
- **Источник:** Patient Flow · **Подписчики:** AI Diagnostics, Billing, BI
- **Контракт:** `{ "encounter_id","patient_id","doctor_id","completed_at","service_code" }`

---

## AI Diagnostics

### AIStudyCompleted
- **Источник:** AI Diagnostics · **Подписчики:** Patient Flow, BI (метаданные), Notifications
- **Семантика:** ИИ завершил обработку исследования, готово заключение.
- **Контракт (для BI без мед. содержимого):**
  ```json
  { "inference_id":"uuid", "study_id":"uuid", "encounter_id":"uuid",
    "model_version":"string", "completed_at":"timestamp", "status":"done|failed" }
  ```

---

## Lending

### LoanApplicationSubmitted
- **Источник:** Lending · **Подписчики:** Accounts (скоринг), BI
- **Контракт:** `{ "application_id","client_id","amount","currency","submitted_at" }`

### LoanContractCreated
- **Источник:** Lending · **Подписчики:** Accounts, Billing, BI, Notifications
- **Семантика:** заявка одобрена, договор заключён.
- **Контракт:**
  ```json
  { "contract_id":"uuid", "application_id":"uuid", "client_id":"uuid",
    "account_id":"uuid", "principal":1000000, "currency":"RUB",
    "rate":0.18, "term_months":24, "created_at":"timestamp" }
  ```

### LoanRepaid
- **Источник:** Lending · **Подписчики:** Accounts, BI, Notifications
- **Контракт:** `{ "contract_id","repaid_at","final_amount" }`

---

## Accounts & Payments

### AccountOpened
- **Источник:** Accounts & Payments · **Подписчики:** Billing, BI
- **Контракт:** `{ "account_id","client_id","currency","opened_at" }`

### TransactionPosted
- **Источник:** Accounts & Payments · **Подписчики:** BI, Notifications, Антифрод
- **Контракт:**
  ```json
  { "transaction_id":"uuid", "account_id":"uuid", "amount":1500.00,
    "currency":"RUB", "direction":"debit|credit", "posted_at":"timestamp",
    "idempotency_key":"string" }
  ```

---

## Сводная таблица

| Событие | Источник | Подписчики | Критичность |
|---------|----------|------------|-------------|
| PatientRegistered | Patient Flow | BI, Billing, Notifications | Средняя |
| AppointmentScheduled | Patient Flow | Clinic Ops, Notifications | Низкая |
| EncounterCompleted | Patient Flow | AI Diagnostics, Billing, BI | Средняя |
| AIStudyCompleted | AI Diagnostics | Patient Flow, BI, Notifications | Высокая |
| LoanApplicationSubmitted | Lending | Accounts, BI | Средняя |
| LoanContractCreated | Lending | Accounts, Billing, BI, Notifications | Высокая |
| LoanRepaid | Lending | Accounts, BI, Notifications | Средняя |
| AccountOpened | Accounts | Billing, BI | Средняя |
| TransactionPosted | Accounts | BI, Notifications, Антифрод | Высокая |
```
