#!/usr/bin/env bash 

script_dir=$(readlink -f $(dirname $0))
. "$script_dir/../library.sh"

. "$script_dir/env.sh"
if [[ -f "$script_dir/../../docker_env.sh" ]]; then
    . "$script_dir/../../docker_env.sh"
fi

instance_name="keycloak-$KEYCLOAK_VERSION"
instace=$(docker_ls | grep ^$instance_name)
id=$(echo $instace | cut -d';' -f2)
running=false
if [[ "$(echo $instace | cut -d';' -f3)" == "running" ]]; then
  running=true
fi

# this is a windows docker work around for mount paths
KEYCLOAK_DATA_DIR=$(normalize_windows_path "$KEYCLOAK_DATA_DIR")

cat <<-EOF
CONFIG
================================================================================
KEYCLOAK_VERSION:           $KEYCLOAK_VERSION
KEYCLOAK_LISTEN_PORT:       $KEYCLOAK_LISTEN_PORT
KEYCLOAK_DATA_DIR:          $KEYCLOAK_DATA_DIR
KEYCLOAK_RESET_STATE_DATA:  $KEYCLOAK_RESET_STATE_DATA
================================================================================

EOF

# stop if it's running
if [[ $running == true ]]; then
  echo "Stopping running instance ..."
  docker container stop "$instance_name" >/dev/null || true
fi

# try to remove if it exists and has to be recycled
if [ $KEYCLOAK_RESET_STATE_DATA == true ] && [ ! -z "$id" ]; then
  echo "Deleting existing instance ..."
  docker container rm "$instance_name" >/dev/null 2>/dev/null || true
fi

# create container and import data if we:
# - do not recycle (reuse old state data) or ...
# - if the instance does not yet exist
if [ $KEYCLOAK_RESET_STATE_DATA == true ] || [ -z "$id" ]; then
  echo "Starting fresh instance ..."
  id=$(docker run --name "$instance_name" \
      --detach \
      -p $KEYCLOAK_LISTEN_PORT:8443 \
      -e KEYCLOAK_ADMIN=admin \
      -e KEYCLOAK_ADMIN_PASSWORD=password \
      -v "$KEYCLOAK_DATA_DIR":/opt/keycloak/data/import \
      keycloak-provider-$KEYCLOAK_VERSION \
      start --optimized \
      --import-realm \
      --hostname=localhost \
      --hostname-port=$KEYCLOAK_LISTEN_PORT)
else
  echo "Starting existing instance ..."
  out=$(docker start "$instance_name")
fi

cat <<-EOF

================================================================================
Keycloak $KEYCLOAK_VERSION is starting, you can access the service here:

Instance Id: $id
Admin:       https://localhost:$KEYCLOAK_LISTEN_PORT/admin
Realsm:      https://localhost:$KEYCLOAK_LISTEN_PORT/realms/<REALM>/account

Default realms are 'master' and 'myrealm'. 'myrealm' has a defult user
    username: user
    password: password

Admin user is:
    username: admin
    password: password

EOF

if [ $KEYCLOAK_RESET_STATE_DATA == true ]; then
cat <<-EOF

With every reload, realm data is imported from this folder:
$KEYCLOAK_DATA_DIR

Set \$KEYCLOAK_RESET_STATE_DATA=false in docker_env.sh to disable this
behaviour.

EOF
fi