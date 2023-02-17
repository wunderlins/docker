#!/usr/bin/env bash

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"

. "$script_dir/config.sh"

# if the container exists, we do not create it
instance_name="haproxy-provider-$HAPROXY_VERSION"
docker_image_exists "$instance_name"

# create default env file
docker_use_config "$script_dir"

# run build process
docker build \
    --file "$script_dir/Dockerfile" \
    --build-arg IMAGE_VERSION="$HAPROXY_VERSION" \
    "$script_dir" -t haproxy-provider-$HAPROXY_VERSION
