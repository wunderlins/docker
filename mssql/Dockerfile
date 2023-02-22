# find image versions here:
# https://hub.docker.com/_/microsoft-mssql-server
#FROM mcr.microsoft.com/mssql/server:2022-latest
ARG IMAGE_VERSION=latest

FROM mcr.microsoft.com/mssql/server:$IMAGE_VERSION as builder
WORKDIR /src
COPY scripts/entrypoint.sh entrypoint.sh
COPY scripts/setup_database.sh setup_database.sh
RUN echo "pw: $SA_PASSWORD"
#ENTRYPOINT ["bash", "./entrypoint.sh", "$SA_PASSWORD"]
CMD /bin/bash ./entrypoint.sh "$SA_PASSWORD" > /tmp/startup.log 2>&1
