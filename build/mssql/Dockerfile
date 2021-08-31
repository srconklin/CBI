FROM mcr.microsoft.com/mssql/server:2019-latest

# Copy initialization scripts
COPY . .

# build arguments only accessible at build time from .env file or listed in compose file
ARG SA_PASSWORD

USER root

# Grant permissions for the run-initialization script to be executable
RUN chmod +x run-initialization.sh

# ENV SA_PASSWORD CorrectHorseBatteryStapleFor$
# ENV ACCEPT_EULA Y

# Run Microsoft SQl Server and initialization script (at the same time)
# Note: If you want to start MsSQL only (without initialization script) you can comment bellow line out, CMD entry from base image will be taken
CMD /bin/bash ./entrypoint.sh
