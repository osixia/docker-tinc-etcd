FROM osixia/tinc:0.1.0
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Use baseimage's init system.
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/run
CMD ["/container/tool/run"]

# Install multiple process stack from baseimage
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-multiple-process-stack
RUN apt-get -y update \
    && /container/tool/install-multiple-process-stack

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yaml /container/environment/env.yaml

# Set tinc config directory in a data volume
VOLUME ["/etc/tinc"]

EXPOSE 655/tcp 655/udp
