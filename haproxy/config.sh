################################################################################
# SET HAPROXY VERSION HERE
################################################################################

## @brief version to deploy
## see https://hub.docker.com/_/haproxy/ for available versions
HAPROXY_VERSION=latest

## @brief data directory from where to load exported realms
HAPROXY_DATA_DIR="$script_dir/import"

## @brief port to listen on
HAPROXY_LISTEN_PORT=8888

## @brief recreate realm data on every start from import directory
HAPROXY_RESET_STATE_DATA=true
