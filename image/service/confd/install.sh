#!/bin/bash -e
# this script is run during the image build

mkdir -p /etc/confd/conf.d
mkdir -p /etc/confd/templates

# add bin
ln -s /container/service/confd/assets/confd /usr/local/bin/confd

# add config file
ln -s /container/service/confd/assets/confd.toml /etc/confd/confd.toml

# add template resource
ln -s /container/service/confd/assets/conf.d/* /etc/confd/conf.d/

# add template
ln -s /container/service/confd/assets/templates/* /etc/confd/templates/
