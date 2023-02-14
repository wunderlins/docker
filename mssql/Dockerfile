# find image versions here:
# https://hub.docker.com/_/microsoft-mssql-server
#FROM mcr.microsoft.com/mssql/server:2022-latest
ARG IMAGE_VERSION=latest

FROM mcr.microsoft.com/mssql/server:$IMAGE_VERSION as builder

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=abcDEF123#
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=1433
WORKDIR /src
#COPY filldata.sql ./filldata.sql
#RUN (/opt/mssql/bin/sqlservr --accept-eula & ) | \
#	grep -q "Service Broker manager has started" &&  \
#	/opt/mssql-tools/bin/sqlcmd -S127.0.0.1 -Usa -PabcDEF123# -i filldata.sql