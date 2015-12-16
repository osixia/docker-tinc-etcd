#!/bin/bash -e

# get nodes from env var
ETCD_NODES=""
TINC_CONFD_ETCD_NODES=($TINC_CONFD_ETCD_NODES)
for node in "${TINC_CONFD_ETCD_NODES[@]}"
do
  #host var contain a variable name, we access to the variable value and cast it to a table
  node_txt=${!node}

  # it's a node stored in a variable
  if [ -n "${node_txt}" ]; then
    ETCD_NODES="$ETCD_NODES -node ${node_txt}"

  # directly
  else
    ETCD_NODES="$ETCD_NODES -node ${node}"
  fi
done

# etcd certs
TINC_CONFD_CLIENT_CAKEYS=""
if [ -n "${TINC_CONFD_CLIENT_CAKEYS_FILENAME}" ]; then
  TINC_CONFD_CLIENT_CAKEYS="-client-ca-keys /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_CAKEYS_FILENAME"
fi

TINC_CONFD_CLIENT_CERT=""
if [ -n "${TINC_CONFD_CLIENT_CERT_FILENAME}" ]; then
  TINC_CONFD_CLIENT_CERT="-client-cert /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_CERT_FILENAME"
fi

TINC_CONFD_CLIENT_KEY=""
if [ -n "${TINC_CONFD_CLIENT_KEY_FILENAME}" ]; then
  TINC_CONFD_CLIENT_KEY="-client-key /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_KEY_FILENAME"

  chmod 600 /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_KEY_FILENAME
fi

echo "exec confd $ETCD_NODES -interval $TINC_CONFD_INTERVAL -log-level $TINC_CONFD_LOG_LEVEL $TINC_CONFD_CLIENT_CAKEYS $TINC_CONFD_CLIENT_CERT $TINC_CONFD_CLIENT_KEY"
exec confd $ETCD_NODES -interval $TINC_CONFD_INTERVAL -log-level $TINC_CONFD_LOG_LEVEL $TINC_CONFD_CLIENT_CAKEYS $TINC_CONFD_CLIENT_CERT $TINC_CONFD_CLIENT_KEY
