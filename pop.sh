#!/bin/bash

# for ANY state transition.
# "notify" script is called AFTER the
# notify_* script(s) and is executed
# with 3 arguments provided by keepalived
# (ie don't include parameters in the notify line).
# arguments
# $1 = "GROUP"|"INSTANCE"
# $2 = name of group or instance
# $3 = target state of transition
#     ("MASTER"|"BACKUP"|"FAULT")

TYPE=$1
NAME=$2
STATE=$3

STATE_FILE="/etc/keepalived/state"

logger -s -t keepalived-notify State $STATE.
echo $STATE > $STATE_FILE

if [ "$STATE" = "MASTER" ]; then

  logger -s -t keepalived-notify I\'m the MASTER! Whup whup.

  # ask failover
  API_TOKEN="5f88a190e533332a17c52e97330f54472235ec59"
  RESULT="false"

  # try until we have the failover and we still are the master
  while [ "${RESULT,,}" = "false" -a "$STATE" = "MASTER" ]; do

    #RESULT=`curl -X POST \
    #     -H "Authorization: Bearer $API_TOKEN" \
    #     -H "X-Pretty-JSON: 1" \
    #     --data "source=212.129.0.170&destination=$COREOS_PUBLIC_IPV4"\
    #     "https://api.online.net/api/v1/server/failover/edit"`
    logger -s -t keepalived-notify Ask failover result: $RESULT
    RESULT="false"

    STATE=$(cat $STATE_FILE)

  done

else
  logger -s -t keepalived-notify Ok, i\'m just a backup, great.
fi
