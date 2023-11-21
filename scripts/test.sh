#!/bin/bash

set -e

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export APIURL=http://realworld-127-0-0-1.sslip.io:80

USERNAME=${USERNAME:-u$(date +%s)}
EMAIL=${EMAIL:-$USERNAME@mail.com}
PASSWORD=${PASSWORD:-password}

set -x

npx newman run $SCRIPTDIR/../Conduit.postman_collection.json \
  --delay-request 500 \
  --global-var "APIURL=${APIURL}" \
  --global-var "USERNAME=$USERNAME" \
  --global-var "EMAIL=$EMAIL" \
  --global-var "PASSWORD=$PASSWORD" \
  "$@"
