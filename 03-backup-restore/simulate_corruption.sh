#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_FILE="$PROJECT_ROOT/volumes/sql1/data/testdata_a.mdf"
docker stop sql1
sudo chmod 666 "$TARGET_FILE"
sudo dd if=/dev/zero of="$TARGET_FILE" bs=1 count=4096 conv=notrunc
docker start sql1
sleep 20
