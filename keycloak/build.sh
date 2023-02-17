#!/usr/bin/env bash

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"

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

# if the container exists, we do not create it
instance_name="keycloak-$KEYCLOAK_VERSION"
instace=$(docker_ls | grep ^$instance_name)
if [ ! -z "$instace" ]; then
    echo "$instance_name exists, delete it to recreate instance."
    exit 0;
fi

# create default env file
if [[ ! -f "$script_dir/../../docker_env.sh" ]]; then
    echo "Generating default env.sh file"
    echo "KEYCLOAK=true" > "$script_dir/env.sh"
    echo '# keycloak version, see https://quay.io/repository/keycloak/keycloak?tab=tags' \
         >> "$script_dir/env.sh"
    echo "KEYCLOAK_VERSION=$KEYCLOAK_VERSION"                     >> "$script_dir/env.sh"
    echo '# port where https is provided for the web interface '  >> "$script_dir/env.sh"
    echo "KEYCLOAK_LISTEN_PORT=$KEYCLOAK_LISTEN_PORT"             >> "$script_dir/env.sh"
    echo '# Directory containing realm JSON files for import'     >> "$script_dir/env.sh"
    echo "KEYCLOAK_DATA_DIR=$KEYCLOAK_DATA_DIR"                   >> "$script_dir/env.sh"
    echo '# recreate realms from import dir on every start?'      >> "$script_dir/env.sh"
    echo "KEYCLOAK_RESET_STATE_DATA=$KEYCLOAK_RESET_STATE_DATA"   >> "$script_dir/env.sh"
else
    echo "using project env file @ $(readlink -f $script_dir/../../docker_env.sh)"
    . "$script_dir/../../docker_env.sh"
fi

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION=$KEYCLOAK_VERSION \
    "$script_dir" -t keycloak-provider-$KEYCLOAK_VERSION
