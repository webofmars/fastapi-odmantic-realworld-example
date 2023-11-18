#!/bin/bash

set -e

export APIURL=http://localhost:8000
cd realworld
./api/run-api-tests.sh
cd -
