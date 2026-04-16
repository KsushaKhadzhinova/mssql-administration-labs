#!/bin/bash
S="localhost,14331"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -S $S -U sa -P $P -C"

echo "Running Lab 1.2 Tasks..."
echo "1. Creating Database and Filegroups..."
$CMD -i create_test_db.sql

echo "2. Configuring Schemas and User Ownership..."
$CMD -i manage_schemas_users.sql

echo "3. Verifying File Locations..."
$CMD -i check_db_files.sql
