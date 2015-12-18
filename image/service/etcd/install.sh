#!/bin/bash -e
# this script is run during the image build

ln -s /container/service/etcd/assets/etcdctl /usr/sbin/etcdctl
ln -s /container/service/etcd/assets/etcdctl-cmd /usr/sbin/etcdctl-cmd
