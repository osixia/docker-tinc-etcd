#!/bin/bash -e

TINC_HOSTNAME=$(echo $TINC_HOSTNAME | sed -e 's/[^a-zA-Z0-9\-]/_/g')

while true; do

  CONFIG=$(cat /etc/tinc/hosts/$TINC_HOSTNAME)
  etcdctl-cmd set $TINC_ETCD_KEY_DIR$TINC_HOSTNAME "\"$CONFIG"\" --ttl $TINC_ETCD_KEY_TTL
  sleep $TINC_ETCD_KEY_UPDATE_INTERVAL

done
