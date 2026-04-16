#!/bin/bash
S1="localhost,14331"
S2="localhost,14332"
S3="localhost,14333"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -U sa -P $P -C"

echo "Running Lab 2.2: Replication & High Availability..."

echo "1. Configuring Distributor on SQL1..."
$CMD -S $S1 -i setup_replication_distributor.sql

echo "2. Creating Publication on SQL1..."
$CMD -S $S1 -i create_transactional_publication.sql

echo "3. Creating Replica Database on SQL2..."
$CMD -S $S2 -Q "CREATE DATABASE ProjectDB_Replica;"

echo "4. Setting up Push Subscription to SQL2..."
$CMD -S $S1 -i setup_push_subscription.sql

echo "5. Initializing Log Shipping on SQL3..."
$CMD -S $S3 -i configure_log_shipping.sql

echo "HA and Replication configuration complete."
