#!/usr/bin/env bash

# a collection of helper functions. incloud with source like:
# source library.sh

## @brief machine readable list of docker images
## @param filter (optional) a list of filter criterias 
## @see https://docs.docker.com/engine/reference/commandline/ps/#filtering
## @return String list of proccess in the format container_id;container_name;running|exited
function docker_ls() {
    first_line_done=false;
    local IFS="
"

    if [[ ! -z "$1" ]]; then f="--filter $1"; fi
    for line in $(docker ps --all --no-trunc --format "table {{.Names}};{{.ID}};{{.State}}"); do
        # skip header
        if [[ $first_line_done == false ]]; then
            first_line_done=true;
        else
            echo $line;
        fi
    done
}

## @brief docker on WSL seems to mangle mount paths, use backslashes
##
## This function only works if `cygpath.exe` can be found in $PATH. If not
## the original string will be returned
##
## @note this is a windows docker work around for mount paths
## @param path unix path to directory or file
## @return windows path with backslashes and drive letter
function normalize_windows_path() {
    if [[ -x "`which cygpath.exe`" ]]; then
        cygpath.exe -m "$1" | sed -e 's,/,\\,gm'
    else
        echo "$1"
    fi
}

## @brief attach a rot console to a container
##
## 
## @note if param 1 (cotainer name) is missing, a list of containers will be shown
## @param container name
## @return void
function docker_console() {
    if [[ -z "$1" ]]; then
        docker_ls;
        return;
    fi

    docker container exec -it $1 bash
}

## @brief bueild a config file
##
## This wil build a default config file for all containers. it will 
## overwrite the exiting config if there is any
##
function docker_create_config() {
    if [[ ! -d docker-images ]]; then
        echo "Thsi command must be run one folder above the docker-images repo";
        exit 1;
    fi

    project_name=$(basename $(readlink -f ..))

    cat <<-EOF> docker-env.sh
        # docker test image configuration.
        # to enable, set «<FEATURE>_START=true»
        #

        PROJECT=$project_name

EOF

    echo "WARNING: set project name 'PROJECT=$project_name' before usage"

}