FROM python:3.11-slim as python-base

FROM python-base as builder-base
RUN apt-get update && apt-get install -y nginx \
    && apt-get install --no-install-recommends -y \
    curl \
    build-essential

ENV POETRY_VERSION=1.4.2\
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/" \
    VENV_PATH="/.venv" 

# Prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

ENV TINI_VERSION v0.18.0


RUN pip3 install poetry
RUN pip3 install Flask
RUN pip3 install jupyter
RUN pip3 install jupyter_kernel_gateway


ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod +x /tini

# switch working directory
WORKDIR $PYSETUP_PATH
COPY . .

RUN poetry config virtualenvs.create false
RUN poetry install --no-dev 


ENTRYPOINT ["/tini", "--", "./start.sh"]
