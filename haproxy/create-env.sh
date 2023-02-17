#!/usr/bin/env bash

cat <<EOF
HAPROXY_START=false
# hyproxy version, see https://hub.docker.com/_/haproxy/'
HAPROXY_VERSION=$HAPROXY_VERSION
# port where haproxy is listening 
# make sure to configure in sync with import/haproxy.cfg 
HAPROXY_LISTEN_PORT=$HAPROXY_LISTEN_PORT
# reset data on every start 
HAPROXY_RESET_STATE_DATA=$HAPROXY_RESET_STATE_DATA
# data directory to mount 
HAPROXY_DATA_DIR=$HAPROXY_DATA_DIR


EOF