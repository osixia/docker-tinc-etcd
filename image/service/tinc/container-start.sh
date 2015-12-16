#!/bin/bash -x

FIRST_START_DONE="/etc/docker-tinc-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  TINC_HOSTNAME=$(echo $TINC_CONFD_PUBLIC_IP | sed -e 's/[^a-zA-Z0-9\-]/_/g')

  /usr/sbin/tinc init $TINC_HOSTNAME
  /usr/sbin/tinc add Address = $TINC_CONFD_PUBLIC_IP

  # add root user on specified networks
  TINC_RUN_BEFORE_START_COMMANDS=($TINC_RUN_BEFORE_START_COMMANDS)
  for command in "${TINC_RUN_BEFORE_START_COMMANDS[@]}"
  do
    echo "Run tinc command: ${!command}"
    /usr/sbin/tinc ${!command}
  done

  # the config is done
  # we add this host public config file to etcd

  # try each nodes
  for node in "${TINC_CONFD_ETCD_NODES[@]}"
  do
    #host var contain a variable name, we access to the variable value and cast it to a table
    node_txt=${!node}

    # it's a node stored in a variable
    if [ -n "${node_txt}" ]; then
      ETCD_NODE=${node_txt}

    # directly
    else
      ETCD_NODE=${node}
    fi

    # etcd certs
    TINC_CONFD_CLIENT_CAKEYS=""
    if [ -n "${TINC_CONFD_CLIENT_CAKEYS_FILENAME}" ]; then
      TINC_CONFD_CLIENT_CAKEYS="--cacert /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_CAKEYS_FILENAME"
    fi

    TINC_CONFD_CLIENT_CERT=""
    if [ -n "${TINC_CONFD_CLIENT_CERT_FILENAME}" ]; then
      TINC_CONFD_CLIENT_CERT="--cert /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_CERT_FILENAME"
    fi

    TINC_CONFD_CLIENT_KEY=""
    if [ -n "${TINC_CONFD_CLIENT_KEY_FILENAME}" ]; then
      TINC_CONFD_CLIENT_KEY="--key /container/service/etcd/assets/certs/$TINC_CONFD_CLIENT_KEY_FILENAME"
    fi

    CONFIG=$(cat /etc/tinc/hosts/$TINC_HOSTNAME)
    curl -L $ETCD_NODE/v2/keys/_osixia.net/tinc/$TINC_CONFD_PUBLIC_IP $TINC_CONFD_CLIENT_CAKEYS $TINC_CONFD_CLIENT_CERT $TINC_CONFD_CLIENT_KEY -XPUT -d value="$CONFIG"

    # success
    if [ "$?" -eq 0 ]; then
      break  # Skip entire rest of nodes
    fi

  done

  # copy tinc.conf and add confd template
  cp -f /etc/tinc/tinc.conf /etc/confd/templates/tinc.tmpl
  cat /etc/confd/templates/tinc.tmpl.partial >> /etc/confd/templates/tinc.tmpl

fi

exit 0
