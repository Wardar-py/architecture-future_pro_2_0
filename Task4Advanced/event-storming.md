# Event Storming - целевая событийная архитектура

Диаграмма основных доменных событий, их источников (Publisher) и подписчиков
(Subscriber). Легенда: 🟧 событие, 🟦 команда, 🟨 агрегат, 🟩 политика/реакция.


## Матрица «событие → издатель → подписчики»

| Событие | Издатель (source) | Подписчики (consumers) |
|---------|-------------------|------------------------|
| `PatientRegistered` - Зарегистрирован новый пациент | Patient Flow | BI, Billing, Notifications |
| `AppointmentScheduled` - Назначен приём | Patient Flow | Clinic Operations, Notifications |
| `EncounterCompleted` - Проведён приём | Patient Flow | AI Diagnostics, Billing, BI |
| `StudyUploaded` - Загружено исследование | AI Diagnostics | AI Diagnostics (внутр.) |
| `AIStudyCompleted` - Пройдено исследование ИИ | AI Diagnostics | Patient Flow, BI (метаданные), Notifications |
| `LoanApplicationSubmitted` - Подана заявка на кредит | Lending | Accounts (скоринг), BI |
| `LoanContractCreated` - Создан кредитный договор | Lending | Accounts, Billing, BI, Notifications |
| `LoanRepaid` - Кредит погашен | Lending | Accounts, BI, Notifications |
| `AccountOpened` - Открыт счёт | Accounts & Payments | Billing, BI |
| `TransactionPosted` - Проведена транзакция | Accounts & Payments | BI, Notifications, антифрод |

## Ключевые элементы событийной инфраструктуры

- **Топики по доменам** в Kafka (`patient.*`, `ai.*`, `lending.*`, `accounts.*`).
- **Schema Registry** - контракты событий, контроль совместимости версий.
- **DLQ** (Dead Letter Queue) на каждый consumer-поток для ошибочных сообщений.
- **Outbox pattern** в доменных сервисах - надёжная публикация событий.

