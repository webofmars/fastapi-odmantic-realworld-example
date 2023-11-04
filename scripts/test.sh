#!/bin/bash
# pytest -n auto -s -c pytest.ini
export APIURL=http://localhost:8000
cd realworld
./api/run-api-tests.sh
cd -
