#!/bin/bash -e

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

  # copy tinc.conf and add confd template
  cp -f /etc/tinc/tinc.conf /etc/confd/templates/tinc.tmpl
  cat /etc/confd/templates/tinc.tmpl.partial >> /etc/confd/templates/tinc.tmpl

fi

exit 0
