#!/usr/bin/env bash 

script_dir=$(readlink -f $(dirname $0))

. "$script_dir/env.sh"
if [[ -f "$script_dir/../../docker_env.sh" ]]; then
    . "$script_dir/../../docker_env.sh"
fi

# this is a windows docker work around for mount paths
if [[ -x "`which cygpath.exe`" ]]; then
  KEYCLOAK_DATA_DIR=$(cygpath.exe -m "$KEYCLOAK_DATA_DIR" | sed -e 's,/,\\,gm')
fi

cat <<-EOF
  CONFIG
  ==============================================================================
  KEYCLOAK_VERSION:     $KEYCLOAK_VERSION
  KEYCLOAK_LISTEN_PORT: $KEYCLOAK_LISTEN_PORT
  KEYCLOAK_DATA_DIR:    $KEYCLOAK_DATA_DIR
  ==============================================================================

EOF

docker container stop "keycloak-$KEYCLOAK_VERSION" || true
docker container rm "keycloak-$KEYCLOAK_VERSION" || true
docker run --name "keycloak-$KEYCLOAK_VERSION" \
    --detach \
    -p $KEYCLOAK_LISTEN_PORT:8443 \
    -e KEYCLOAK_ADMIN=admin \
    -e KEYCLOAK_ADMIN_PASSWORD=password \
    -v "$KEYCLOAK_DATA_DIR":/opt/keycloak/data/import \
    keycloak-provider-$KEYCLOAK_VERSION \
    start --optimized \
    --hostname=localhost \
    --import-realm \
    --hostname-port=$KEYCLOAK_LISTEN_PORT

cat <<-EOF

================================================================================
Keycloak $KEYCLOAK_VERSION is starting, you can access the service here:

https://localhost:$KEYCLOAK_LISTEN_PORT/admin
https://localhost:$KEYCLOAK_LISTEN_PORT/realms/<REALM>/account

Default realms are 'master' and 'myrealm'. 'myrealm' has a defult user
    username: user
    password: password

Admin user is:
    username: admin
    password: password

With every reload, realm data is imported from this folder:
$KEYCLOAK_DATA_DIR

EOF