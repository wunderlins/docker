#!/usr/bin/env bash

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"
. "$script_dir/config.sh"

# if the container exists, we do not create it
instance_name="mssql-provider-$MSSQL_VERSION"
docker_image_exists "$instance_name"

# create default env file
docker_use_config "$script_dir"

# run build process
docker build \
    --file "$script_dir/Dockerfile.old" \
    --build-arg IMAGE_VERSION="$MSSQL_VERSION" --build-arg MSSQL_SA_PASSWORD="$MSSQL_SA_PASSWORD" \
    "$script_dir" -t mssql-provider-$MSSQL_VERSION
