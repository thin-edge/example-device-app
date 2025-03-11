FROM ghcr.io/thin-edge/tedge-demo-main-systemd:20250130.1508
ARG TEST_USER=iotadmin

# Install additional dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        git \
        jq \
        curl \
        bc \
    && tedge config unset c8y.proxy.client.host \
    && tedge config unset mqtt.client.host \
    && tedge config unset http.client.host

# Install latest from main release channel
RUN wget -O - thin-edge.io/install.sh | sh -s -- --channel main

COPY dist/*.deb /tmp/
RUN dpkg -i --force-overwrite /tmp/*.deb \
    && mkdir -p /opt/packages \
    && cp /tmp/*.deb /opt/packages/ \
    && rm -f /tmp/*.deb
