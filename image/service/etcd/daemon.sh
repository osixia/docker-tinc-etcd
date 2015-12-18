#!/bin/bash -e

# get initial config
for ip in `etcdctl-cmd ls /_osixia.net/tinc/ | sed -e 's/\/_osixia.net\/tinc\///'`; do
  if [ "$TINC_CONFD_PUBLIC_IP" != "$ip" ]; then
    host=$(echo $ip | sed -e 's/[^a-zA-Z0-9\-]/_/g')
    tinc add ConnectTo = $host
    etcdctl-cmd get /_osixia.net/tinc/$ip | sed -e 's/\"//g' > /srv/tinc/hosts/$host
  fi
done

exec etcdctl-cmd exec-watch --recursive /_osixia.net/tinc/ -- /node/tinc/tool/tinc-config-updater.sh
