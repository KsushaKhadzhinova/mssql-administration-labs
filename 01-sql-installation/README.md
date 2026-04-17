# Lab 1.1: MS SQL Server Installation and Connectivity

Эта лабораторная работа — фундамент проекта. Цель: развертывание трех экземпляров SQL Server и подтверждение их готовности.

---

## Содержимое папки

| Файл | Описание |
|------|----------|
| `check_version.sql` | Проверка версии, редакции (Edition) и обновлений |
| `check_instances.sh` | Проверка статуса контейнеров через Docker API |
| `verify_connectivity.sh` | Проверка сетевой доступности портов 14331-14333 |

---

## Пошаговое выполнение

### Шаг 1: Проверка статуса контейнеров

```bash
chmod +x check_instances.sh
./check_instances.sh
```

### Шаг 2: Верификация редакции (Критически важно)

Developer/Enterprise Edition требуется для репликации и автоматизации:

```bash
sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -i check_version.sql
```

### Шаг 3: Проверка удаленного подключения

```bash
chmod +x verify_connectivity.sh
./verify_connectivity.sh
```

---

## Ожидаемые результаты

| Параметр | Ожидаемое значение |
|----------|--------------------|
| Контейнеры | Все 3 инстанса: `Up` или `Healthy` |
| Edition | `Developer Edition` |
| Connectivity | Каждый порт отвечает именем сервера |

---

## Технические заметки

### Выбор портов

Диапазон `14331-14333` вместо `1433`:
- Избегает конфликтов с локальным SQL Server на Windows
- Имитирует именованные экземпляры в корпоративной сети

### Почему важна проверка Edition?

**SQL Server Express** не поддерживает:
- SQL Server Agent (Лаба 2.1)
- Replication (Лаба 2.2)

**Образ:** `mcr.microsoft.com/mssql/server:2022-latest` = Developer Edition по умолчанию

### Безопасность

Флаг `-C` (Trust Server Certificate) используется из-за самоподписанных сертификатов в Docker.
