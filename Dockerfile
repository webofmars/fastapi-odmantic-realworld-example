FROM python:3.10-slim-buster as base

WORKDIR /app
COPY requirements.txt requirements.txt

# hadolint ignore=DL3042,DL3013
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

FROM base as prod
COPY src/ /app/

FROM prod as dev
COPY requirements-dev.txt requirements-dev.txt
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y git curl && \
    rm -rf /var/lib/apt/lists/* && \
    pip install -r requirements-dev.txt

ENTRYPOINT ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]

RUN export DEBIAN_FRONTEND=noninteractive && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*
