# Docker templates

## 1. Add repo
add this repo as submodule to the project you are working on:
```bash
mkdir docker
touch docker/docker-images/docker_env.sh
git add docker docker/docker-images/docker_env.sh

git submodule add git@github.com:wunderlins/docker-images.git docker/docker-images
git commit -m "added docker" .gitmodules docker/

git push
```

## 2. add config

add a bash script with the docker config called `docker_env.sh` or create
a default config:

```bash
cd docker
. ./docker-images/library.sh
docker_create_config
```

edit `docker-env.sh` and at least set one `XXX_START` variables to true. Also 
check paths, you may set your project specific data directories.

## 3. run

in the docker folder where `docker-env.sh` is, run rhwe follwoing command:

```bash
cd docker
. ./docker-images/library.sh
docker_start # will create images, initialize and start
```
