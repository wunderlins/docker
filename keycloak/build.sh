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
DEFAULT_VERSION=latest
DEFAULT_PORT=8443 # listen port for the service, must duffer for every cotnainer
DEFAULT_DATA_DIR="$script_dir/import"

if [[ ! -f "$script_dir/../../docker_env.sh" ]]; then
    echo "KEYCLOAK_VERSION=$DEFAULT_VERSION"     > "$script_dir/env.sh"
    echo "KEYCLOAK_LISTEN_PORT=$DEFAULT_PORT"   >> "$script_dir/env.sh"
    echo "KEYCLOAK_DATA_DIR=$DEFAULT_DATA_DIR"  >> "$script_dir/env.sh"
else
    . "$script_dir/../../docker_env.sh"
fi

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION=$DEFAULT_VERSION \
    "$script_dir" -t keycloak-provider-$DEFAULT_VERSION
