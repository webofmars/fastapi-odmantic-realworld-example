#!/bin/bash

set -eu -o pipefail
pytest -s -c pytest.ini
