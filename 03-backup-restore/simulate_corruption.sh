#!/bin/bash
# Определяем корневую папку проекта (на один уровень выше текущей папки 03)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_FILE="$PROJECT_ROOT/volumes/sql1/data/testdata_a.mdf"

echo "Stopping sql1 to simulate hardware failure..."
docker stop sql1

echo "Setting permissions for corruption..."
# Выдаем права, чтобы dd точно сработал
sudo chmod 666 "$TARGET_FILE"

echo "Corrupting the primary data file..."
sudo dd if=/dev/zero of="$TARGET_FILE" bs=1 count=4096 conv=notrunc

echo "Restarting sql1..."
docker start sql1
echo "Waiting 15s for SQL Server to initialize..."
sleep 15
