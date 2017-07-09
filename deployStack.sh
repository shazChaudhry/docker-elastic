#!/bin/bash

export ELASTIC_VERSION=5.5.0
docker stack deploy -c docker-compose.yml logging
