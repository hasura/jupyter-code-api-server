#!/usr/bin/env bash
set -e

flask run --port 6060 &

# set htpasswd for nginx basic auth
htpasswd -db -c /etc/nginx/.htpasswd hasura $(cat /etc/connector/config.json | jq -r '.password')

nginx -c "$PWD/nginx.conf" &

cd /notebook && jupyter notebook --allow-root --config /jupyter_notebook_config.py &

wait -n
