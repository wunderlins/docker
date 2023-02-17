#!/usr/bin/env bash

cat <<EOF
KEYCLOAK_START=false

# keycloak version, see https://quay.io/repository/keycloak/keycloak?tab=tags
KEYCLOAK_VERSION=$KEYCLOAK_VERSION
# port where https is provided for the web interface 
KEYCLOAK_LISTEN_PORT=$KEYCLOAK_LISTEN_PORT
# Directory containing realm JSON files for import
KEYCLOAK_DATA_DIR=$KEYCLOAK_DATA_DIR
# recreate realms from import dir on every start?
KEYCLOAK_RESET_STATE_DATA=$KEYCLOAK_RESET_STATE_DATA

EOF