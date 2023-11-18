FROM python:3.10-slim-buster as base

WORKDIR /app
COPY requirements.txt requirements.txt

# hadolint ignore=DL3042,DL3013
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

FROM base as prod
COPY src/ /app/
ENTRYPOINT ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]

FROM base as dev

# hadolint ignore=DL3008,DL3015
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y --no-install-recommends git curl make && \
    rm -rf /var/lib/apt/lists/*

COPY requirements-dev.txt requirements-dev.txt
# hadolint ignore=DL3042
RUN pip install -r requirements-dev.txt

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3015
RUN export DEBIAN_FRONTEND=noninteractive && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

COPY . /app/

ENTRYPOINT ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
