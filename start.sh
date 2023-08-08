#!/usr/bin/env bash
set -e

#SET_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"
DEFAULT_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"

#PASSWORD="${SET_PASSWORD:-$DEFAULT_PASSWORD}"

# set htpasswd for nginx basic auth
htpasswd -db -c /etc/nginx/.htpasswd hasura "$DEFAULT_PASSWORD"

supervisord -c /supervisor/supervisord.conf -n &
SUPERVISOR_PID=$!

wait $SUPERVISOR_PID
