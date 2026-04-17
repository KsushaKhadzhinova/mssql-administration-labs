#!/bin/bash
docker-compose down -v
sudo rm -rf ./shared/backup/*
sudo rm -rf ./volumes/sql1/data/*
sudo rm -rf ./volumes/sql2/data/*
sudo rm -rf ./volumes/sql3/data/*
docker ps -a --filter "name=sql"
