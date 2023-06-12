#!/bin/bash

set -e

docker run --rm -d --name mongodb \
  -e MONGODB_ROOT_PASSWORD="root" \
  -e MONGODB_USERNAME="app" \
  -e MONGODB_PASSWORD="app" \
  -e MONGODB_DATABASE="test" \
  -p 27017:27017 \
  bitnami/mongodb:4.4-debian-10
