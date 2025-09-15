FROM debian AS downloader
ARG BIOCASE_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends curl unzip ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN curl -L -o biocase.zip https://git.bgbm.org/biocase/bps/-/archive/${BIOCASE_VERSION}/bps-${BIOCASE_VERSION}.zip && \
    unzip biocase.zip && \
    rm biocase.zip && \
    mv bps-${BIOCASE_VERSION} biocase

FROM python:slim@sha256:58c30f5bfaa718b5803a53393190b9c68bd517c44c6c94c1b6c8c172bcfad040
MAINTAINER Joerg Holetschek <j.holetschek@bgbm.org>
MAINTAINER Petr Novotný <novotp@natur.cuni.cz>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2 pkg-config g++ unixodbc-dev libmariadb-dev  \
    graphviz default-jre-headless && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

RUN pip install lxml pyodbc pymssql psycopg2-binary mysqlclient fdb legacy-cgi

# Set Apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2

# Enable cgi
RUN /usr/sbin/a2enmod cgid

# Checkout BioCASe
WORKDIR /opt
COPY --from=downloader --chown=$APACHE_RUN_GROUP:$APACHE_RUN_USER /opt/biocase /opt/biocase
# Keep initial config values for Kubernetes volume mount
RUN cp -r /opt/biocase/config /opt/biocase/config-initial

# Set bpsPath in lib/biocase/addjustpath.py to r'/opt/biocase'
RUN sed -i 's/C:\\Workspace\\bps3/\/opt\/biocase/g' /opt/biocase/lib/biocase/adjustpath.py

RUN cd /opt/biocase/tools && python fixpermissions.py

COPY biocase.conf /etc/apache2/sites-enabled/000-default.conf

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOG_DIR && \
    chown -R $APACHE_RUN_GROUP:$APACHE_RUN_USER $APACHE_RUN_DIR $APACHE_LOG_DIR && \
    chmod -R 755 $APACHE_RUN_DIR $APACHE_LOG_DIR

USER $APACHE_RUN_USER
EXPOSE 80

# Start Apache
CMD rm -f $APACHE_RUN_DIR/apache2.pid && /usr/sbin/apache2ctl -D FOREGROUND
