#!/usr/bin/env bash
set -o pipefail

mkdir -p "$MNT_DIR"

backup_notebook_to_bucket() {
    while true; do
        sleep 60
        echo "triggering backup"
        gsutil -m rsync -r "$MNT_DIR" "gs://$K_SERVICE/notebook"
        echo "backup done"
    done
}

# don't backup to GCS in local dev
if [ "$LOCAL_DEV" == "yes" ]; then
  echo "Local dev is configured, don't setup backup"
  cp -r /notebook "$MNT_DIR"
else
  echo "Local dev is not setup, configure backup"
  # check if notebook folder exists
  gsutil ls "gs://$K_SERVICE/notebook" > /dev/null 2>&1
#  gsutil -q stat "gs://$K_SERVICE/notebook/server.ipynb"

  PATH_EXIST=$?
  if [ ${PATH_EXIST} -eq 0 ]; then
    echo "folder exists, copying bucket contents to cloud run"
    gsutil -m cp -r "gs://$K_SERVICE/notebook" "$MNT_DIR"
  else
    echo "folder does not exist"
    gsutil -m cp -r /notebook "gs://$K_SERVICE/notebook"
  fi

#  echo "Mounting GCS Fuse."
#  echo "Mounting Bucket $K_SERVICE at $MNT_DIR"
#  gcsfuse --implicit-dirs "$K_SERVICE" "$MNT_DIR"
#  #gcsfuse --implicit-dirs --only-dir "$K_SERVICE/" --debug_http --debug_gcs --debug_fuse $BUCKET $MNT_DIR
#  echo "Mounting completed."
  backup_notebook_to_bucket &
fi

#SET_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"
DEFAULT_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"

#PASSWORD="${SET_PASSWORD:-$DEFAULT_PASSWORD}"

# set htpasswd for nginx basic auth
htpasswd -db -c /etc/nginx/.htpasswd hasura "$DEFAULT_PASSWORD"

supervisord -c /supervisor/supervisord.conf -n &
SUPERVISOR_PID=$!

wait $SUPERVISOR_PID
