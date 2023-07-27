#!/usr/bin/env bash
set -e

#export GOOGLE_APPLICATION_CREDENTIALS="/sa.json"
#gcloud auth activate-service-account no-permissions@hasura-connector-deploy-prod.iam.gserviceaccount.com --key-file /sa.json --project hasura-connector-deploy-prod
echo "$K_SERVICE" > service.txt
gsutil cp service.txt gs://$BUCKET/$K_SERVICE/service.txt

# Create mount directory for service
mkdir -p $MNT_DIR
echo "Mounting GCS Fuse."
echo " $MNT_DIR $BUCKET $K_SERVICE"
gcsfuse --foreground --only-dir "$K_SERVICE/" --debug_gcs --debug_fuse $BUCKET $MNT_DIR 
echo "Mounting completed."

#SET_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"
DEFAULT_PASSWORD="$(cat /etc/connector/config.json | jq -r '.password')"

#PASSWORD="${SET_PASSWORD:-$DEFAULT_PASSWORD}"

flask run --port 6060 &

# set htpasswd for nginx basic auth
htpasswd -db -c /etc/nginx/.htpasswd hasura "$DEFAULT_PASSWORD"

nginx -c "$PWD/nginx.conf" &

cd /notebook && jupyter notebook --allow-root --config /jupyter_notebook_config.py &

wait -n
