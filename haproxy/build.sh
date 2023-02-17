#!/usr/bin/env bash

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"

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

# if the container exists, we do not create it
instance_name="haproxy-$HAPROXY_VERSION"
instace=$(docker_ls | grep ^$instance_name)
if [ ! -z "$instace" ]; then
    echo "$instance_name exists, delete it to recreate instance."
    exit 0;
fi

# create default env file
if [[ ! -f "$script_dir/../../docker_env.sh" ]]; then
    echo "HAPROXY_START=false" > "$script_dir/env.sh"
    echo "Generating default env.sh file"
    echo '# hyproxy version, see https://hub.docker.com/_/haproxy/' \
         >> "$script_dir/env.sh"
    echo "HAPROXY_VERSION=$HAPROXY_VERSION"                     >> "$script_dir/env.sh"
    echo '# port where haproxy is listening '  >> "$script_dir/env.sh"
    echo '# make sure to configure in sync with import/haproxy.cfg '  >> "$script_dir/env.sh"
    echo "HAPROXY_LISTEN_PORT=$HAPROXY_LISTEN_PORT"             >> "$script_dir/env.sh"
    echo '# reset data on every start '  >> "$script_dir/env.sh"
    echo "HAPROXY_RESET_STATE_DATA=$HAPROXY_RESET_STATE_DATA"             >> "$script_dir/env.sh"
    echo '# data directory to mount '  >> "$script_dir/env.sh"
    echo "HAPROXY_DATA_DIR=$HAPROXY_DATA_DIR"             >> "$script_dir/env.sh"
    echo "" >> "$script_dir/env.sh"
    echo "" >> "$script_dir/env.sh"
else
    echo "using project env file @ $(readlink -f $script_dir/../../docker_env.sh)"
    . "$script_dir/../../docker_env.sh"
fi

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION="$HAPROXY_VERSION" \
    "$script_dir" -t haproxy-provider-$HAPROXY_VERSION
