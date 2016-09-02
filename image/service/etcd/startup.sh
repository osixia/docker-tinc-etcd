#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

ln -sf ${CONTAINER_SERVICE_DIR}/etcd/assets/etcdctl-cmd /usr/sbin/etcdctl-cmd

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-etcd-first-start-done"
# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  if [ "${TINC_ETCD_CLIENT_TLS,,}" == "true" ]; then
    # backend ssl
    # generate a certificate and key if files don't exists
    # https://github.com/osixia/docker-light-baseimage/blob/stable/image/service-available/:ssl-tools/assets/tool/ssl-helper
    ssl-helper ${TINC_ETCD_CLIENT_SSL_HELPER_PREFIX} "${CONTAINER_SERVICE_DIR}/etcd/assets/certs/$TINC_ETCD_CLIENT_CERT_FILENAME" "${CONTAINER_SERVICE_DIR}/etcd/assets/certs/$TINC_ETCD_CLIENT_KEY_FILENAME" "${CONTAINER_SERVICE_DIR}/etcd/assets/certs/$TINC_ETCD_CLIENT_CA_FILENAME"
  fi
  touch $FIRST_START_DONE
fi
