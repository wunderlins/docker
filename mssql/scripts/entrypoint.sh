#!/usr/bin/env bash
set -m
/opt/mssql/bin/sqlservr --accept-eula & /bin/bash /src/scripts/setup_database.sh 
fg