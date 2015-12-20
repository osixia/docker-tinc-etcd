#!/bin/bash -e

# wait tinc service
sv start tinc || exit 1

TINC_HOSTNAME=$(echo $HOSTNAME | sed -e 's/[^a-zA-Z0-9\-]/_/g')

# get initial config
for host in `etcdctl-cmd ls $TINC_ETCD_KEY_DIR | sed -e "s|${TINC_ETCD_KEY_DIR}||g"`; do
  if [ "$TINC_HOSTNAME" != "$host" ]; then
    etcdctl-cmd get $TINC_ETCD_KEY_DIR$host | sed -e 's/\"//g' > /etc/tinc/hosts/$host
    tinc add ConnectTo = $host
  fi
done

sv start tinc && tinc reload

exec etcdctl-cmd exec-watch --recursive $TINC_ETCD_KEY_DIR -- /container/service/etcd-watcher/assets/tinc-config-updater.sh
