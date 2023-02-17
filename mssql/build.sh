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
MSSQL_VERSION=2022-latest

## @brief port to listen on
MSSQL_LISTEN_PORT=1433 # listen port for the service, must duffer for every cotnainer

## @brief data directory from where to load exported realms
MSSQL_DATA_DIR="$script_dir/import"

## @brief recreate realm data on every start from import directory
MSSQL_RESET_STATE_DATA=true

# system admin password
MSSQL_SA_PASSWORD=abcDEF123#

# if the container exists, we do not create it
instance_name="mssql-$MSSQL_VERSION"
instace=$(docker_ls | grep ^$instance_name)
if [ ! -z "$instace" ]; then
    echo "$instance_name exists, delete it to recreate instance."
    exit 0;
fi

# create default env file
if [[ ! -f "$script_dir/../../docker_env.sh" ]]; then
    echo "Generating default env.sh file"
    echo "MSSQL_START=false" > "$script_dir/env.sh"
    echo '# mssql version, see https://quay.io/repository/keycloak/keycloak?tab=tags&tag=latest' \
         >> "$script_dir/env.sh"
    echo "MSSQL_VERSION=$MSSQL_VERSION"                     >> "$script_dir/env.sh"
    echo '# port where mssql is listening '  >> "$script_dir/env.sh"
    echo "MSSQL_LISTEN_PORT=$MSSQL_LISTEN_PORT"             >> "$script_dir/env.sh"
    echo '# SA password '  >> "$script_dir/env.sh"
    echo "MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD"             >> "$script_dir/env.sh"
    echo '# reset data on every start '  >> "$script_dir/env.sh"
    echo "MSSQL_RESET_STATE_DATA=$MSSQL_RESET_STATE_DATA"             >> "$script_dir/env.sh"
    echo '# data directory to mount '  >> "$script_dir/env.sh"
    echo "MSSQL_DATA_DIR=$MSSQL_DATA_DIR"             >> "$script_dir/env.sh"
    echo "" >> "$script_dir/env.sh"
    echo "" >> "$script_dir/env.sh"
else
    echo "using project env file @ $(readlink -f $script_dir/../../docker_env.sh)"
    . "$script_dir/../../docker_env.sh"
fi

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION="$MSSQL_VERSION" --build-arg MSSQL_SA_PASSWORD="$MSSQL_SA_PASSWORD" \
    "$script_dir" -t mssql-provider-$MSSQL_VERSION
