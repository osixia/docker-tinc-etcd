#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

ln -s ${CONTAINER_SERVICE_DIR}/etcd/assets/etcdctl /usr/sbin/etcdctl
ln -s ${CONTAINER_SERVICE_DIR}/etcd/assets/etcdctl-cmd /usr/sbin/etcdctl-cmd
