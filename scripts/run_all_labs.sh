#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

docker-compose -f "$PROJECT_ROOT/docker-compose.yml" down -v --remove-orphans

sudo rm -rf "$PROJECT_ROOT/volumes/sql1/data/"*
sudo rm -rf "$PROJECT_ROOT/volumes/sql1/log/"*
sudo rm -rf "$PROJECT_ROOT/volumes/sql1/backup/"*

sudo rm -rf "$PROJECT_ROOT/volumes/sql2/data/"*
sudo rm -rf "$PROJECT_ROOT/volumes/sql2/log/"*

sudo rm -rf "$PROJECT_ROOT/volumes/sql3/data/"*
sudo rm -rf "$PROJECT_ROOT/volumes/sql3/log/"*

docker network prune -f
