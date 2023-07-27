FROM python:3

RUN apt update && apt install -y nginx

RUN pip install openai
RUN pip install langchain
RUN pip install weaviate-client
RUN pip install gql[all]
RUN pip install Flask
RUN pip install jupyter
RUN pip install jupyter_kernel_gateway
COPY notebook /notebook


ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

WORKDIR /src
COPY . .

ENTRYPOINT ["/tini", "--", "./start.sh"]
