FROM osixia/tinc:0.2.3

ARG ETCD_VERSION=3.3.10

# Install multiple process stack from baseimage
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-multiple-process-stack
RUN apt-get -y update \
    && /container/tool/add-multiple-process-stack \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && /container/tool/add-service-available :ssl-tools \
    && curl -o etcd.tar.gz -SL https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf etcd.tar.gz etcd-v${ETCD_VERSION}-linux-amd64/etcdctl \
    && mv etcd-v${ETCD_VERSION}-linux-amd64/etcdctl /usr/sbin/etcdctl \
    && chmod +x /usr/sbin/etcdctl \
    && rm -rf  etcd-v${ETCD_VERSION}-linux-amd64 etcd.tar.gz \
    && apt-get remove -y --purge --auto-remove curl ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service

# Add default env variables
# to folder 98-default to not override
# tinc image default env files in 99-default directory
ADD environment /container/environment/98-default

EXPOSE 655/tcp 655/udp
