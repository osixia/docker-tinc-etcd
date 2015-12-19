#!/bin/bash -e

# wait tinc service
sv start tinc || exit 1

TINC_HOSTNAME=$(echo $HOSTNAME | sed -e 's/[^a-zA-Z0-9\-]/_/g')

while true; do

  CONFIG=$(cat /etc/tinc/hosts/$TINC_HOSTNAME)
  etcdctl-cmd set $TINC_ETCD_KEY_DIR$TINC_HOSTNAME "\"$CONFIG"\" --ttl $TINC_ETCD_KEY_TTL > /dev/null
  sleep $TINC_ETCD_KEY_UPDATE_INTERVAL

done
