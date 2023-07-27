FROM python:3

#RUN apt update && apt install -y nginx jq apache2-utils
# Install system dependencies
RUN set -e; \
    apt-get update -y && apt-get install -y \
    nginx \
    jq \
    apache2-utils \
    curl apt-transport-https ca-certificates \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse google-cloud-sdk \
    && apt-get clean

# Set fallback mount directory
ENV MNT_DIR /mnt/gcs
ENV BUCKET hasura-jupyter-notebook-store
ENV K_SERVICE dev_connector


RUN pip install Flask
RUN pip install jupyter
RUN pip install jupyter_kernel_gateway

#RUN mkdir /etc/nginx
#RUN mkdir /etc/connector

COPY notebook /notebook
COPY config.json /config.json
COPY config.json /etc/connector/config.json
COPY jupyter_notebook_config.py /jupyter_notebook_config.py


ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

WORKDIR /src
COPY app.py start.sh nginx.conf ./
COPY static static

ENTRYPOINT ["/tini", "--", "./start.sh"]
