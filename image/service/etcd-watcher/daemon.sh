#!/bin/bash -e

# get initial config
for host in `etcdctl-cmd ls $TINC_ETCD_KEY_DIR | sed -e 's|$TINC_ETCD_KEY_DIR||'`; do
  if [ "$TINC_HOSTNAME" != "$host" ]; then
    etcdctl-cmd get $TINC_ETCD_KEY_DIR$host | sed -e 's/\"//g' > /etc/tinc/hosts/$host
  fi
done

exec etcdctl-cmd exec-watch --recursive $TINC_ETCD_KEY_DIR -- /container/service/etcd-watcher/assets/tinc-config-updater.sh
