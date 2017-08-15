#!/bin/bash

export ELASTIC_VERSION=5.5.1
docker stack deploy -c docker-compose.yml logging
