# Docker templates

Every sub folder contains a prepared configuration for an application. Enter the 
directory and copy the `_env` file to `.env`. this is the config file you 
need to change.

When the `.env` file is created and configured, run the image like so:

## first run

```bash
docker compose build
docker compose up -d
```

## subsequent run
```bash
docker compose up -d
```