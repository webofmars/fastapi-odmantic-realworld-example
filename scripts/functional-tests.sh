#!/bin/bash

set -e

echo "Waiting for API container to be up"
bash scripts/wait-for-it.sh localhost:8000 --timeout=60 --strict -- echo "API is up"
echo "Waiting for API to be healthy"
until curl --output /dev/null --silent --fail http://localhost:8000/health; do
    printf '.'
    sleep 5
done
echo ""
echo "API is healthy"
echo "Running functional tests"
bash scripts/test.sh
