# Base Chrome Headless image
FROM golang:1.9

# System setup
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    TIMEZONE=UTC

# Build args
ARG CHROME_VERSION="google-chrome-stable"
ARG CHROME_DRIVER_VERSION="latest"

RUN set -x \
    # Basic .bashrc
    && echo 'alias ll="ls -laF"' >> /root/.bashrc \
    && echo 'alias e="exit"' >> /root/.bashrc \
    && echo 'alias cls="clear"' >> /root/.bashrc \
    # System software
    && apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
        ca-certificates \
        gnupg \
        libcap2-bin \
        tzdata \
        wget \
    # System configuration
    && echo $TIMEZONE > /etc/timezone \
    && DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure --frontend noninteractive tzdata \
    && go get -u github.com/golang/dep/cmd/dep \
    # Install Chrome
    && groupadd -r chrome \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install ${CHROME_VERSION:-google-chrome-stable} \
    # Cleanup
    && rm /etc/apt/sources.list.d/google.list \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
