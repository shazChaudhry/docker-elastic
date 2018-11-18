#!/bin/bash

docker network create --driver overlay elastic
ELASTIC_VERSION=6.5.0 docker stack deploy -c docker-compose.yml elastic
