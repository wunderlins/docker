#!/usr/bin/env bash
# Wait for database to startup 
sleep 8

echo "Setting up database" > /tmp/database.log
echo /src/import/*.sql >> /tmp/database.log
for f in /src/import/*.sql; do
	echo "$f" >> /tmp/database.log
	/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -i "$f" >> /tmp/database.log 2>&1
done