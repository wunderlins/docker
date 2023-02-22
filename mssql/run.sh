#!/usr/bin/env bash

docker compose build
docker compose up -d

SA_PASSWORD=$(grep SA_PASSWORD docker-compose.yaml | sed -e 's/[^"]\+//; s/"//g')
echo "sa: $SA_PASSWORD"