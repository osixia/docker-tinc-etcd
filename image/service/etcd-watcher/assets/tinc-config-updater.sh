#!/bin/sh

key=${ETCD_WATCH_KEY}
host=$(echo $key | sed -e "s|${TINC_ETCD_KEY_DIR}||g")

TINC_HOSTNAME=$(echo $HOSTNAME | sed -e 's/[^a-zA-Z0-9\-]/_/g')

if [ $TINC_HOSTNAME != $host ]; then

  if [ "$ETCD_WATCH_ACTION" = "set" ]; then
    current_value="";
    if [ -f ${CONTAINER_SERVICE_DIR}/tinc/data/hosts/$host ]; then
      current_value="$( cat ${CONTAINER_SERVICE_DIR}/tinc/data/hosts/$host )"
    fi
    if [ "$ETCD_WATCH_VALUE" != "\"$current_value\"" ]; then
      etcdctl-cmd get $TINC_ETCD_KEY_DIR$host | sed -e 's/\"//g' > ${CONTAINER_SERVICE_DIR}/tinc/data/hosts/$host
      tinc --config ${CONTAINER_SERVICE_DIR}/tinc/data add ConnectTo = $host
      sv start /container/run/process/tinc && tinc reload
    fi
  fi
  if [ "$ETCD_WATCH_ACTION" = "delete" ] || [ "$ETCD_WATCH_ACTION" = "expire" ]; then
    tinc --config ${CONTAINER_SERVICE_DIR}/tinc/data del ConnectTo = $host
    sv start /container/run/process/tinc && tinc reload
    rm -f ${CONTAINER_SERVICE_DIR}/tinc/data/hosts/$host
  fi
fi
