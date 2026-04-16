#!/bin/bash

# =================================================================
# MSSQL Labs Cleanup Script
# Удаляет контейнеры, сети и ТОМА (Volumes) с данными
# =================================================================

echo "--------------------------------------------------------"
echo "Starting system cleanup..."
echo "--------------------------------------------------------"

# 1. Остановка и удаление контейнеров вместе с томами
# Флаг -v критически важен: он удаляет физические файлы баз данных
docker-compose down -v

# 2. Очистка локальных папок с логами и бэкапами (если они были созданы)
echo "Cleaning up local shared folders..."
sudo rm -rf ./shared/backup/*
sudo rm -rf ./volumes/sql1/data/*
sudo rm -rf ./volumes/sql2/data/*
sudo rm -rf ./volumes/sql3/data/*

# 3. Проверка остаточных процессов
echo "Checking for remaining SQL containers..."
docker ps -a --filter "name=sql"

echo "--------------------------------------------------------"
echo "Cleanup complete. Your environment is fresh and clean!"
echo "--------------------------------------------------------"
