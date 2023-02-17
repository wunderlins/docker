#!/usr/bin/env bash

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"

. "$script_dir/config.sh"

# if the container exists, we do not create it
instance_name="haproxy-$HAPROXY_VERSION"
instace=$(docker_ls | grep ^$instance_name)
if [ ! -z "$instace" ]; then
    echo "$instance_name exists, delete it to recreate instance."
    exit 0;
fi

# create default env file
if [[ ! -f "$script_dir/../../docker_env.sh" ]]; then
    . "$script_dir/create-env.sh" > "$script_dir/env.sh"
else
    echo "using project env file @ $(readlink -f $script_dir/../../docker_env.sh)"
    . "$script_dir/../../docker_env.sh"
fi

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION="$HAPROXY_VERSION" \
    "$script_dir" -t haproxy-provider-$HAPROXY_VERSION
