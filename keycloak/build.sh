#!/usr/bin/env bash

script_dir=$(readlink -f $(dirname $0))

################################################################################
# SET KEYCLOAK VERSION HERE
################################################################################
# find image versions here:
# https://quay.io/repository/keycloak/keycloak?tab=tags&tag=latest
# if you omit the --build-arg IMAGE_VERSION then 
# latest (stable) will be used. or you might set it to
# '--build-arg IMAGE_VERSION=latest' which has the same effect 
# as ommitting
KEYCLOAK_VERSION=latest
KEYCLOAK_LISTEN_PORT=8443 # listen port for the service, must duffer for every cotnainer
KEYCLOAK_DATA_DIR="$script_dir/import"

if [[ ! -f "$script_dir/../../docker_env.sh" ]]; then
    echo "Generating default env.sh file"
    echo "KEYCLOAK_VERSION=$KEYCLOAK_VERSION"            > "$script_dir/env.sh"
    echo "KEYCLOAK_LISTEN_PORT=$KEYCLOAK_LISTEN_PORT"   >> "$script_dir/env.sh"
    echo "KEYCLOAK_DATA_DIR=$KEYCLOAK_DATA_DIR"         >> "$script_dir/env.sh"
else
    echo "using project env file @ $(readlink -f $script_dir/../../docker_env.sh)"
    . "$script_dir/../../docker_env.sh"
fi

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION=$KEYCLOAK_VERSION \
    "$script_dir" -t keycloak-provider-$KEYCLOAK_VERSION
