#!/usr/bin/env bash
set -o pipefail

#export GOOGLE_APPLICATION_CREDENTIALS="/sa.json"
#gcloud auth activate-service-account no-permissions@hasura-connector-deploy-prod.iam.gserviceaccount.com --key-file /sa.json --project hasura-connector-deploy-prod

# check if file exist 
gsutil -q stat gs://$BUCKET/$K_SERVICE/notebook/server.ipynb

PATH_EXIST=$?
if [ ${PATH_EXIST} -eq 0 ]; then
  echo "bucket exist"
else
  echo "bucket does not exist"
  gsutil -m cp -r /notebook gs://$BUCKET/$K_SERVICE/notebook
fi

# Create mount directory for service
mkdir -p $MNT_DIR
echo "Mounting GCS Fuse."
echo " $MNT_DIR $BUCKET $K_SERVICE"
gcsfuse --implicit-dirs --only-dir "$K_SERVICE/" $BUCKET $MNT_DIR 
#gcsfuse --implicit-dirs --only-dir "$K_SERVICE/" --debug_gcs --debug_fuse $BUCKET $MNT_DIR 
echo "Mounting completed."

ls -l $MNT_DIR

#SET_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"
DEFAULT_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"

#PASSWORD="${SET_PASSWORD:-$DEFAULT_PASSWORD}"

flask run --port 6060 &

# set htpasswd for nginx basic auth
htpasswd -db -c /etc/nginx/.htpasswd hasura "$DEFAULT_PASSWORD"

nginx -c "$PWD/nginx.conf" &

cd /mnt/gcs/notebook && jupyter notebook --allow-root --config /jupyter_notebook_config.py &

wait -n
