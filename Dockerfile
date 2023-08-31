FROM us-east1-docker.pkg.dev/hasura-connector-deploy-prod/notebook-prebuilt/notebook:20230901

ENTRYPOINT ["/tini", "--", "./start.sh"]