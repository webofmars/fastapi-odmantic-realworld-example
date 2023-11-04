#!/bin/bash

nohup poetry run uvicorn --app-dir ./src/ api:app &
