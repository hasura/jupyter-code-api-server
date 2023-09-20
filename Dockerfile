FROM python:3

ARG DEBIAN_FRONTEND=noninteractive
RUN set -e; \
    apt-get update -y && apt-get install -y \
    nginx \
    jq \
    apache2-utils \
    curl apt-transport-https ca-certificates \
    lsb-release; \
    echo "deb http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y google-cloud-sdk \
    && apt-get clean

# Set fallback mount directory
ENV MNT_DIR /mnt/gcs

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# supervisor
RUN pip install supervisor git+https://github.com/coderanger/supervisor-stdout

COPY notebook /notebook
COPY config.json /config.json
COPY config.json /etc/connector/config.json
COPY jupyter_notebook_config.py /jupyter_notebook_config.py

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

WORKDIR /src
COPY app.py start.sh nginx.conf ./
COPY frontend frontend
COPY supervisor/ /supervisor/
RUN chmod +x /supervisor/stop-supervisor.sh

ENTRYPOINT ["/tini", "--", "./start.sh"]
