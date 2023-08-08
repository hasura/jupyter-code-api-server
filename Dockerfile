FROM python:3

RUN apt update && apt install -y nginx jq apache2-utils

ARG DEBIAN_FRONTEND=noninteractive
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y build-essential nodejs npm

RUN pip install Werkzeug
RUN pip install openai
RUN pip install langchain
RUN pip install weaviate-client
RUN pip install gql[all]
RUN pip install Flask
RUN pip install jupyter
RUN pip install jupyter_kernel_gateway

# supervisor
RUN pip install supervisor git+https://github.com/coderanger/supervisor-stdout

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
COPY frontend frontend
COPY supervisor/ /supervisor/
#RUN cd frontend && rm -rf ./node_modules && npm install && npm run build && cd ..

ENTRYPOINT ["/tini", "--", "./start.sh"]
