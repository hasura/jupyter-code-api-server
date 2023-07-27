#!/usr/bin/env bash
set -o pipefail

# Create mount directory for service
mkdir -p $MNT_DIR

# don't mount GCS Fuse in local dev
if [ "$LOCAL_DEV" == "yes" ]; then
  echo "Local dev is configured, don't setup fuse"
  cp -r /notebook $MNT_DIR
else
  echo "Local dev is not setup, configure fuse"
  # check if file exist 
  gsutil -q stat gs://$BUCKET/$K_SERVICE/notebook/server.ipynb
  
  PATH_EXIST=$?
  if [ ${PATH_EXIST} -eq 0 ]; then
    echo "bucket exist"
  else
    echo "bucket does not exist"
    gsutil -m cp -r /notebook gs://$BUCKET/$K_SERVICE/notebook
  fi
  
  echo "Mounting GCS Fuse."
  echo " $MNT_DIR $BUCKET $K_SERVICE"
  gcsfuse --implicit-dirs --only-dir "$K_SERVICE/" $BUCKET $MNT_DIR 
  #gcsfuse --implicit-dirs --only-dir "$K_SERVICE/" --debug_http --debug_gcs --debug_fuse $BUCKET $MNT_DIR 
  echo "Mounting completed."
fi

#SET_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"
DEFAULT_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"

#PASSWORD="${SET_PASSWORD:-$DEFAULT_PASSWORD}"

flask run --port 6060 &

# set htpasswd for nginx basic auth
htpasswd -db -c /etc/nginx/.htpasswd hasura "$DEFAULT_PASSWORD"

nginx -c "$PWD/nginx.conf" &

cd /mnt/gcs/notebook && jupyter notebook --allow-root --config /jupyter_notebook_config.py &

wait -n
