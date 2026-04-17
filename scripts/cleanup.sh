#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
docker-compose -f "$PROJECT_ROOT/00-environment-setup/docker-compose.yml" down -v
sudo rm -rf "$PROJECT_ROOT/shared/backup"/*
sudo rm -rf "$PROJECT_ROOT/volumes/sql1/data"/*
sudo rm -rf "$PROJECT_ROOT/volumes/sql2/data"/*
sudo rm -rf "$PROJECT_ROOT/volumes/sql3/data"/*
docker ps -a --filter "name=sql"
