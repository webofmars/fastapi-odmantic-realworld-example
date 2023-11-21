#!/bin/bash

set -e

echo "Starting API stack"
# NOTE: we do not use compose anymore since werf is k8s enabled
#       instead resources will be deployed in our locla kubernetes cluster
werf converge --repo webofmars/cicdparadox

echo "Waiting for API container to be up"
bash scripts/wait-for-it.sh realworld-127-0-0-1.sslip.io:80 --timeout=60 --strict -- echo "API is up"
echo "Waiting for API to be healthy"
until curl --output /dev/null --silent --fail http://realworld-127-0-0-1.sslip.io/health; do
    printf '.'
    sleep 5
done
echo ""
echo "API is healthy"

echo "Running functional tests"
bash scripts/test.sh
werf dismiss --repo webofmars/cicdparadox
