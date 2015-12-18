#!/bin/sh

ip=${ETCD_WATCH_KEY/\/_osixia.net\/tinc\//}

if [ $TINC_CONFD_PUBLIC_IP != $ip ]; then

  host=$(echo $ip | sed -e 's/[^a-zA-Z0-9\-]/_/g')

  if [ "$ETCD_WATCH_ACTION" = "set" ]; then
    current_value="";
    if [ -f /etc/tinc/hosts/$host ]; then
      current_value="$( cat /etc/tinc/hosts/$host )"
    fi
    if [ "$ETCD_WATCH_VALUE" != "\"$current_value\"" ]; then
      etcdctl-cmd get /_osixia.net/tinc/$ip | sed -e 's/\"//g' > /etc/tinc/hosts/$host
    fi
  fi
  if [ "$ETCD_WATCH_ACTION" = "delete" ] || [ "$ETCD_WATCH_ACTION" = "expire" ]; then
    rm -f /etc/tinc/hosts/$host
  fi
fi
