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
KEYCLOAK_VERSION=latest

## @brief port to listen on
KEYCLOAK_LISTEN_PORT=8443 # listen port for the service, must duffer for every cotnainer

## @brief data directory from where to load exported realms
KEYCLOAK_DATA_DIR="$script_dir/import"

## @brief recreate realm data on every start from import directory
KEYCLOAK_RESET_STATE_DATA=true