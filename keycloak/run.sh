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

docker container stop "keycloak-$KEYCLOAK_VERSION" || true
docker container rm "keycloak-$KEYCLOAK_VERSION" || true
docker run --name "keycloak-$KEYCLOAK_VERSION" \
    -p 8443:$KEYCLOAK_LISTEN_PORT \
    -e KEYCLOAK_ADMIN=admin \
    -e KEYCLOAK_ADMIN_PASSWORD=password \
    -v "$KEYCLOAK_DATA_DIR":/opt/keycloak/data/import \
    keycloak-provider-$KEYCLOAK_VERSION \
    start --optimized \
    --hostname=localhost \
    --import-realm

