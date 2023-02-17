#!/usr/bin/env bash

# https://medium.com/bright-days/basic-docker-image-dockerfile-sql-server-with-custom-prefill-db-script-8f12f197867a

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"

. "$script_dir/env.sh"
if [[ -f "$script_dir/../../docker_env.sh" ]]; then
    . "$script_dir/../../docker_env.sh"
fi

instance_name="haproxy-$HAPROXY_VERSION"
instace=$(docker_ls | grep ^$instance_name)
id=$(echo $instace | cut -d';' -f2)
running=false
if [[ "$(echo $instace | cut -d';' -f3)" == "running" ]]; then
  running=true
fi

# this is a windows docker work around for mount paths
HAPROXY_DATA_DIR=$(normalize_windows_path "$HAPROXY_DATA_DIR")

cat <<-EOF
CONFIG
================================================================================
HAPROXY_VERSION:           $HAPROXY_VERSION
HAPROXY_LISTEN_PORT:       $HAPROXY_LISTEN_PORT
HAPROXY_DATA_DIR:          $HAPROXY_DATA_DIR
HAPROXY_RESET_STATE_DATA:  $HAPROXY_RESET_STATE_DATA
================================================================================

EOF

# stop if it's running
if [[ $running == true ]]; then
  echo "Stopping running instance ..."
  docker container stop "$instance_name" >/dev/null || true
fi

# try to remove if it exists and has to be recycled
if [[ $HAPROXY_RESET_STATE_DATA == true ]] && [[ ! -z "$id" ]]; then
  echo "Deleting existing instance ..."
  docker container rm "$instance_name" >/dev/null 2>/dev/null || true
fi

# create container and import data if we:
# - do not recycle (reuse old state data) or ...
# - if the instance does not yet exist
if [[ $HAPROXY_RESET_STATE_DATA == true ]] || [[ -z "$id" ]]; then
  echo "Starting fresh instance ..."
  id=$(docker run --name "$instance_name" \
      --detach \
      -p $HAPROXY_LISTEN_PORT:$HAPROXY_LISTEN_PORT \
      -v "$HAPROXY_DATA_DIR":/usr/local/etc/haproxy/ \
      haproxy-provider-$HAPROXY_VERSION )
else
  echo "Starting existing instance ..."
  out=$(docker start "$instance_name")
fi

echo docker run --name "$instance_name" \
      --detach \
      -p $HAPROXY_LISTEN_PORT:$HAPROXY_LISTEN_PORT \
      -v "$HAPROXY_DATA_DIR":/usr/local/etc/haproxy/ \
      haproxy-provider-$HAPROXY_VERSION

cat <<-EOF

================================================================================
HAPROXY $HAPROXY_VERSION is starting, you can access the service here:

Instance Id: $id

EOF

if [[ $HAPROXY_RESET_STATE_DATA == true ]]; then
cat <<-EOF

EOF
fi