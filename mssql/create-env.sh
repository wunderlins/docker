#!/usr/bin/env bash

cat <<EOF
MSSQL_START=false
# mssql version, see https://quay.io/repository/keycloak/keycloak?tab=tags&tag=latest
MSSQL_VERSION=$MSSQL_VERSION
# port where mssql is listening 
MSSQL_LISTEN_PORT=$MSSQL_LISTEN_PORT
# SA password 
MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD
# reset data on every start 
MSSQL_RESET_STATE_DATA=$MSSQL_RESET_STATE_DATA
# data directory to mount 
MSSQL_DATA_DIR=$MSSQL_DATA_DIR

EOF