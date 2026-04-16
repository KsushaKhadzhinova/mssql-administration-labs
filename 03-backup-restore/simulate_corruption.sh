#!/bin/bash
echo "Stopping sql1 to simulate hardware failure..."
docker stop sql1

echo "Corrupting the primary data file (testdata_a.mdf)..."
# Overwriting the first 4096 bytes with zeros
sudo dd if=/dev/zero of=./volumes/sql1/data/testdata_a.mdf bs=1 count=4096 conv=notrunc

echo "Restarting sql1..."
docker start sql1

echo "Waiting for SQL Server to start..."
sleep 15

echo "Checking database status (Expected: RECOVERY_PENDING or SUSPECT)..."
/opt/mssql-tools18/bin/sqlcmd -S localhost,14331 -U sa -P 'YourStrongPassword123!' -C -Q "SELECT name, state_desc FROM sys.databases WHERE name = 'Test';"
