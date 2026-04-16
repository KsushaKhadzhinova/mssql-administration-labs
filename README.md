# MS SQL Server Administration: Full Laboratory Portfolio
**Студент:** Ксения Хаджинова  
**Стек:** Docker, SQL Server 2022 (Linux), Ubuntu (WSL2), Bash

Этот репозиторий содержит полный цикл работ по администрированию Microsoft SQL Server: от развертывания инфраструктуры до настройки репликации и мониторинга производительности.

---

## Архитектура инфраструктуры
Проект развернут в изолированной сети Docker и состоит из трех узлов, что позволяет имитировать работу распределенной корпоративной среды.

* **sql1 (Port 14331):** Основной узел (Издатель, Дистрибьютор).
* **sql2 (Port 14332):** Узел репликации (Подписчик).
* **sql3 (Port 14333):** Резервный узел (Log Shipping Standby).



---

## Навигация по курсу

| Лабораторная работа | Описание | Скрипты |
| :--- | :--- | :--- |
| **[00-environment-setup](./00-environment-setup)** | Развертывание Docker-инфраструктуры и инициализация данных. | `docker-compose.yml`, `init.sql` |
| **[01-sql-installation](./01-sql-installation)** | Проверка сетевой связности и параметров инстансов. | `check_instances.sh` |
| **[02-database-management](./02-database-management)** | Управление файловыми группами, лимитами роста и схемами. | `create_test_db.sql` |
| **[03-backup-restore](./03-backup-restore)** | Disaster Recovery: бэкапы, имитация порчи файлов и восстановление. | `simulate_corruption.sh` |
| **[04-security-management](./04-security-management)** | Безопасность: роли, пользователи, иерархия GRANT/DENY. | `setup_logins_roles.sql` |
| **[05-admin-automation](./05-admin-automation)** | Автоматизация: SQL Agent Jobs, Alerts и Database Mail. | `configure_agent_mail.sql` |
| **[06-replication-ha](./06-replication-ha)** | Высокая доступность: транзакционная репликация и Log Shipping. | `verify_lab_06.sh` |
| **[07-monitoring-troubleshoot](./07-monitoring-troubleshoot)** | Оптимизация: DMV, Extended Events и Columnstore индексы. | `query_optimization.sql` |

---

## Быстрый запуск

1.  **Клонирование репозитория:**
    ```bash
    git clone [https://github.com/KsushaKhadzhinova/mssql-administration-labs.git](https://github.com/KsushaKhadzhinova/mssql-administration-labs.git)
    cd mssql-administration-labs
    ```

2.  **Запуск инфраструктуры:**
    ```bash
    docker-compose up -d
    ```

3.  **Автоматическое выполнение всех лаб:**
    ```bash
    chmod +x scripts/run_all_labs.sh
    ./scripts/run_all_labs.sh
    ```

## Очистка системы
Чтобы полностью удалить контейнеры, временные данные и сбросить систему до начального состояния, используйте:
```bash
chmod +x scripts/cleanup.sh
./scripts/cleanup.sh
