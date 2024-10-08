FROM debian:bullseye-slim

# Creathe the directory in which magneticod and magneticow will be placed
RUN mkdir -p /opt/magnetico

# Update, upgrade and install some required packages
RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    curl \
    apache2-utils \
    moreutils \
    lsb-base \
    procps \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/doc \
    /usr/share/man \
    /usr/share/locale \
    /usr/share/info \
    /usr/share/lintian
    
# Get magneticod and magneticow
RUN magnetico_latest=$(curl --silent "https://api.github.com/repos/tgragnato/magnetico/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
    && curl -so /opt/magnetico/magneticod -L https://github.com/tgragnato/magnetico/releases/download/$magnetico_latest/magneticod \
    && curl -so /opt/magnetico/magneticow -L https://github.com/tgragnato/magnetico/releases/download/$magnetico_latest/magneticow

VOLUME /root/.local/share/magneticod

ADD magnetico/ /opt/magnetico/
WORKDIR /opt/magnetico

RUN chmod +x /opt/magnetico/*

EXPOSE 8080
CMD ["/opt/magnetico/run.sh"]

ENV MAGNETICOW_PORT=8080
