#!/bin/bash

export ELASTIC_VERSION=5.4.3
docker-compose pull
docker stack deploy -c docker-compose.yml logging
