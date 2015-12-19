#!/bin/bash -e

TINC_HOSTNAME=$(echo $TINC_HOSTNAME | sed -e 's/[^a-zA-Z0-9\-]/_/g')

# get initial config
for host in `etcdctl-cmd ls $TINC_ETCD_KEY_DIR | sed -e "s|${TINC_ETCD_KEY_DIR}||g"`; do
  if [ "$TINC_HOSTNAME" != "$host" ]; then
    tinc add ConnectTo = $host
    etcdctl-cmd get $TINC_ETCD_KEY_DIR$host | sed -e 's/\"//g' > /etc/tinc/hosts/$host
  fi
done

sv reload tinc

exec etcdctl-cmd exec-watch --recursive $TINC_ETCD_KEY_DIR -- /container/service/etcd-watcher/assets/tinc-config-updater.sh
