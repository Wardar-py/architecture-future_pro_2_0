# Расширенный технический радар «Будущее 2.0»

Радар включает **технологии** и **архитектурные паттерны**. Статусы:
- **Adopt** применять по умолчанию, зрелое решение.
- **Trial** пробовать на реальных проектах с контролем рисков.
- **Assess** исследовать, пилотировать точечно.
- **Hold** не начинать новое, выводить из эксплуатации.

## Квадранты радара

### 1. Techniques / Архитектурные паттерны

| Элемент | Статус | Комментарий |
|---------|--------|-------------|
| Event-Driven Architecture | **Adopt** | Ядро целевой платформы |
| Data Mesh | **Adopt** | Доменное владение данными и дата-продуктами |
| Self-Service BI | **Adopt** | Портал витрины данных |
| Domain-Driven Design | **Adopt** | Границы доменов, bounded contexts |
| Anti-Corruption Layer | **Adopt** | Изоляция от legacy DWH/Camel |
| Outbox / CDC | **Adopt** | Надёжная публикация событий |
| Strangler Fig (постепенная замена legacy) | **Trial** | Вывод DWH/Camel |
| CQRS | **Trial** | Разделение чтения/записи в критичных доменах |
| Lakehouse | **Trial** | S3 + Iceberg вместо тяжёлого DWH |
| FinOps | **Trial** | Контроль облачных затрат |
| Data Contracts | **Trial** | Формализация контрактов дата-продуктов |
| Reactive streams end-to-end | **Assess** | Долгосрочная цель near-real-time |
| Point-to-point интеграции (Camel) | **Hold** | Замещаются событиями |

### 2. Platforms / Хранилища и инфраструктура

| Элемент | Статус | Комментарий |
|---------|--------|-------------|
| Yandex Cloud / облако | **Adopt** | Целевая инфраструктура |
| Apache Kafka | **Adopt** | Event backbone |
| S3-совместимое Object Storage | **Adopt** | Хранение и tfstate |
| Apache Iceberg | **Trial** | Табличный формат lakehouse |
| ClickHouse | **Trial** | Доменные аналитические витрины |
| Trino | **Trial** | Федеративные запросы |
| Kubernetes | **Trial** | Оркестрация сервисов |
| SQL Server 2008 (DWH) | **Hold** | Legacy, вывод из эксплуатации |

### 3. Tools / Инструменты

| Элемент | Статус | Комментарий |
|---------|--------|-------------|
| Terraform (IaC) | **Adopt** | Управление инфраструктурой |
| GitHub Actions / GitLab CI | **Adopt** | CI/CD пайплайны |
| Confluent Schema Registry | **Adopt** | Контракты событий |
| Debezium | **Trial** | CDC из legacy |
| Apache Flink | **Trial** | Потоковая обработка |
| OpenMetadata | **Trial** | Data Catalog |
| dbt | **Assess** | Трансформации в lakehouse |
| Power BI | **Trial→Hold** | Мигрируем на self-service BI |
| PowerBuilder | **Hold** | Legacy UI, вывод |

### 4. Languages & Frameworks

| Элемент | Статус | Комментарий |
|---------|--------|-------------|
| Go | **Adopt** | Финтех/платформенные сервисы |
| Python | **Adopt** | ИИ-сервисы, дата-инжиниринг |
| Java | **Adopt** | Финтех-сервисы, стрим-процессинг |
| Kafka Streams | **Trial** | Легковесные потоковые трансформации |
| Apache Camel (ESB) | **Hold** | Legacy интеграционный слой |
