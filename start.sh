#!/usr/bin/env bash
set -e

flask run --port 6060 &
nginx -c "$PWD/nginx.conf" &
cd /notebook && jupyter notebook --ip 0.0.0.0 --port 7070 --allow-root --NotebookApp.base_url=jupyter --NotebookApp.allow_origin='*' &

wait -n
