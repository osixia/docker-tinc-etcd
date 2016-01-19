FROM osixia/tinc:0.1.0
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Install multiple process stack from baseimage
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-multiple-process-stack
RUN apt-get -y update \
    && /container/tool/add-multiple-process-stack

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
# to folder 98-default to not override
# tinc image default env files in 99-default directory
ADD environment /container/environment/98-default

# Set tinc config directory in a data volume
VOLUME ["/etc/tinc"]

EXPOSE 655/tcp 655/udp
