#!/bin/sh

key=${ETCD_WATCH_KEY}
host=$(echo $key | sed -e "s|${TINC_ETCD_KEY_DIR}||g")

TINC_HOSTNAME=$(echo $HOSTNAME | sed -e 's/[^a-zA-Z0-9\-]/_/g')

if [ $TINC_HOSTNAME != $host ]; then

  if [ "$ETCD_WATCH_ACTION" = "set" ]; then
    current_value="";
    if [ -f /etc/tinc/hosts/$host ]; then
      current_value="$( cat /etc/tinc/hosts/$host )"
    fi
    if [ "$ETCD_WATCH_VALUE" != "\"$current_value\"" ]; then
      etcdctl-cmd get $TINC_ETCD_KEY_DIR$host | sed -e 's/\"//g' > /etc/tinc/hosts/$host
      tinc add ConnectTo = $host
      tinc reload
    fi
  fi
  if [ "$ETCD_WATCH_ACTION" = "delete" ] || [ "$ETCD_WATCH_ACTION" = "expire" ]; then
    tinc del ConnectTo = $host
    tinc reload
    rm -f /etc/tinc/hosts/$host
  fi
fi
