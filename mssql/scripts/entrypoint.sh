#!/usr/bin/env bash
set -m
export SA_PASSWORD="$1"
echo "pw: $SA_PASSWORD"
/opt/mssql/bin/sqlservr --accept-eula & /bin/bash /src/scripts/setup_database.sh 
fg