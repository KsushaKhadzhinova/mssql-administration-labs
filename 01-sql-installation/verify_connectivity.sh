S1="localhost,14331"
S2="localhost,14332"
P="YourStrongPassword123!"
CMD="/opt/mssql-tools18/bin/sqlcmd -U sa -P $P -C"

echo "Checking SQL1 (Default Instance equivalent):"
$CMD -S $S1 -Q "SELECT @@SERVERNAME AS ServerName, @@VERSION AS Version;"

echo "Checking SQL2 (Named Instance equivalent):"
$CMD -S $S2 -Q "SELECT @@SERVERNAME AS ServerName;"
