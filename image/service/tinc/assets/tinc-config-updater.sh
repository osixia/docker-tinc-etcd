#!/bin/sh

ip=${ETCD_WATCH_KEY/\/_osixia.net\/tinc\//}

if [ $TINC_CONFD_PUBLIC_IP != $ip ]; then

  host=$(echo $ip | sed -e 's/[^a-zA-Z0-9\-]/_/g')

  if [ "$ETCD_WATCH_ACTION" = "set" ]; then
    current_value="";
    if [ -f /srv/tinc/hosts/$host ]; then
      current_value="$( cat /srv/tinc/hosts/$host )"
    fi
    if [ "$ETCD_WATCH_VALUE" != "\"$current_value\"" ]; then
      tinc add ConnectTo = $host
      etcdctl-cmd get /_osixia.net/tinc/$ip | sed -e 's/\"//g' > /srv/tinc/hosts/$host
      sv reload tinc
    fi
  fi
  if [ "$ETCD_WATCH_ACTION" = "delete" ] || [ "$ETCD_WATCH_ACTION" = "expire" ]; then
    tinc del ConnectTo = $host
    rm -f /srv/tinc/hosts/$host
    sv reload tinc
  fi
fi
