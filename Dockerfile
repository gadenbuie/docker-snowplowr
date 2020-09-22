FROM rocker/verse:4.0.0-ubuntu18.04
ENV TZ=America/New_York

RUN apt-get update && \
  apt-get install -y unixodbc unixodbc-dev --install-suggests && \
  apt-get install -y curl gnupg openssh-client && \
  apt-get install tzdata && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install snowflake odbc drivers
RUN cd /tmp && \
  wget https://sfc-repo.snowflakecomputing.com/odbc/linux/latest/snowflake-odbc-2.22.0.x86_64.deb && \
  dpkg -i snowflake-odbc-2.22.0.x86_64.deb && \
  rm snowflake-odbc-2.22.0.x86_64.deb

# Use RStudio Daily Version
RUN apt-get clean && apt-get update && apt-get install -y gdebi-core
RUN wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-1.4.853-amd64.deb -O /tmp/rstudio-server.deb && \
  gdebi -n /tmp/rstudio-server.deb && \
  rm /tmp/rstudio-server.deb

# Install RStudio Preferences
COPY rstudio-prefs.json /etc/rstudio/rstudio-prefs.json

RUN install2.r dbplyr odbc DBI

