FROM python:3

RUN apt update && apt install -y nginx jq apache2-utils

RUN pip install openai
RUN pip install langchain
RUN pip install weaviate-client
RUN pip install gql[all]
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
