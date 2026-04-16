#!/bin/bash
S="localhost,14331"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -S $S -U sa -P $P -C"

echo "Running Lab 2.3: Monitoring & Troubleshooting..."

echo "1. Collecting DMV Statistics..."
$CMD -i dmv_monitoring.sql

echo "2. Setting up Extended Events (XE)..."
$CMD -i extended_events_setup.sql

echo "3. Performing Query Optimization and Indexing..."
$CMD -i query_optimization.sql

echo "Performance tuning completed. Check plans in output."
