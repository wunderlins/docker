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

add a bash script with the docker config called `docker_env.sh`

# docker_env.sh

see  `*/build.sh` for variables that must be configured.