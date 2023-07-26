#!/usr/bin/env bash
set -e

flask run --port 6060 &
nginx -c "$PWD/nginx.conf" &
cd /notebook && jupyter notebook --allow-root --config /src/jupyter_notebook_config.py &

wait -n
