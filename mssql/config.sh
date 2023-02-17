################################################################################
# SET KEYCLOAK VERSION HERE
################################################################################
# find image versions here:
# https://quay.io/repository/keycloak/keycloak?tab=tags&tag=latest
# if you omit the --build-arg IMAGE_VERSION then 
# latest (stable) will be used. or you might set it to
# '--build-arg IMAGE_VERSION=latest' which has the same effect 
# as ommitting

## @brief version to deploy
## see above where to obtain available versions
MSSQL_VERSION=2022-latest

## @brief port to listen on
MSSQL_LISTEN_PORT=1433 # listen port for the service, must duffer for every cotnainer

## @brief data directory from where to load exported realms
MSSQL_DATA_DIR="$script_dir/import"

## @brief recreate realm data on every start from import directory
MSSQL_RESET_STATE_DATA=true

# system admin password
MSSQL_SA_PASSWORD=abcDEF123#