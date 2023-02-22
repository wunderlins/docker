# find image versions here:
# https://hub.docker.com/_/microsoft-mssql-server
#FROM mcr.microsoft.com/mssql/server:2022-latest
ARG IMAGE_VERSION=latest

FROM mcr.microsoft.com/mssql/server:$IMAGE_VERSION as builder
ARG MSSQL_SA_PASSWORD=Pa55w0rd!
ENV SA_PASSWORD=$MSSQL_SA_PASSWORD
RUN echo "pw: $SA_PASSWORD $MSSQL_SA_PASSWORD"

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=1433
WORKDIR /src

#COPY filldata.sql ./filldata.sql
#RUN (/opt/mssql/bin/sqlservr --accept-eula & ) | \
#	grep -q "Service Broker manager has started" &&  \
#	/opt/mssql-tools/bin/sqlcmd -S127.0.0.1 -Usa -PabcDEF123# -i filldata.sql

#RUN (/opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started"

COPY scripts/entrypoint.sh entrypoint.sh
COPY scripts/setup_database.sh setup_database.sh
#COPY import/*.sql /src/
#USER root
#RUN chmod 755 *.sh *.sql
#USER mssql

RUN echo "pw: $SA_PASSWORD"
CMD /bin/bash ./entrypoint.sh "$SA_PASSWORD" > /tmp/startup.log 2>&1
