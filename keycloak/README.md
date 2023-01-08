# Custom Keycload Environment 

This repo contains a collection of scripts to create and run a custom keycloak
deployment in docker.

Information taken from the official keycloak docker installation manual
[https://www.keycloak.org/server/containers](https://www.keycloak.org/server/containers).

**THIS DEPLOYMENT IS NOT INTENDED TO BE USED IN PRODUCTION ENVIRONMENT**!

## Scripts and configs

- `env.sh`: (created when running build) contains configuration variables to be used in your project
- `build.sh`: does build and deploy the image
- `run.sh`: does start a deployed image
- `Dockerfile`: the container configuration, used to build a new container fro mthe authorative sources with our custom configuration. Use this to build/update the image whenever needed.

## Building the image

To build an image [https://quay.io/repository/keycloak/keycloak?tab=tags&tag=latest](https://quay.io/repository/keycloak/keycloak?tab=tags&tag=latest)

1. run `build.sh`
2. copy content of `env.sh` into your project's `docker_env.sh` file
3. if you don't want to use the latest version, set version in `docker_env.sh`: `KEYCLOAK_VERSION=X.X.X`
4. run `build.sh` again
5. when done, you will find an new docker image called `keycloak-provider-X.X.X` in the console
6. (optional): export realms (see below) and place them in the `KEYCLOAK_DATA_DIR` configured in `docker_env.sh`
7. use `run.sh` to start it

## Provided default Ralms

### master

1. [https://localhost:8443/admin](https://localhost:8443/admin)
2. user `admin`/`password`


### myrealm

1. [http://localhost:8444/realms/myrealm/account](http://localhost:8444/realms/myrealm/account)
2. user `user`, pw: `password`

## export realm data from existing Keycloak instance

You can build a realm for your specific use case and make it persistent.
for that you will have to login to the created keycloak instance, create your realm configuration and then export it into your project as described:

1. use the web interface and create your realm, users, etc.
2. open a root console in the docker container

```bash
cd /opt/keycloak/bin
./kc.sh export --dir /tmp/export --users realm_file
# copy selective if there is only one realm or:
rm -rf /opt/keycloak/data/import/*.json
# copy all but master-realm.json
cp $(find /tmp/export -iname "*.json" | grep -v /master-realm) \
    /opt/keycloak/data/import/
```

Copy all files in `$REPO/docker/keycloak/import` to a folder in your 
project. Make sure to update `$REPO/docker_env.sh` and point
`KEYCLOAK_DATA_DIR=$script_filename/docker-data/import` to the folder 
where you keep your realm data to import on start.

## Container Environment Variables

See `Dockerfile`

- `KEYCLOAK_ADMIN`: admin user
- `KEYCLOAK_ADMIN_PASSWORD`: password for the system admin
- `KC_DB_URL`: postgres database url
- `KC_DB_USERNAME`: pg user
- `KC_DB_PASSWORD`: pg pass
- `KC_HOSTNAME`: (default localhost) pg host name

