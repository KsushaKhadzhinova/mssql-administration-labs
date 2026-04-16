#!/bin/bash
S="localhost,14331"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -S $S -U sa -P $P -C"

echo "Running Lab 1.4: Security Management..."

echo "1. Setting up Logins, Users, and Roles..."
$CMD -i setup_logins_roles.sql

echo "2. Configuring Permissions and Schemas..."
$CMD -i configure_permissions.sql

echo "3. Testing Security Access Policies..."
$CMD -i test_security_access.sql

echo "Security setup verified."
