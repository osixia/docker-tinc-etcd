#!/bin/bash -e

# wait tinc service
sv start /container/run/process/tinc || exit 1

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x


TINC_HOSTNAME=$(echo $HOSTNAME | sed -e 's/[^a-zA-Z0-9\_]/_/g')

while true; do

  CONFIG=$(cat ${CONTAINER_SERVICE_DIR}/tinc/data/hosts/$TINC_HOSTNAME)
  etcdctl-cmd set $TINC_ETCD_KEY_DIR$TINC_HOSTNAME "\"$CONFIG"\" --ttl $TINC_ETCD_KEY_TTL > /dev/null
  sleep $TINC_ETCD_KEY_UPDATE_INTERVAL

done
