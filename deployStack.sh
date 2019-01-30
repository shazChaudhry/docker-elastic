#!/bin/bash

export ELASTIC_VERSION=6.6.0
export ELASTICSEARCH_USERNAME=elastic
export ELASTICSEARCH_PASSWORD=changeme
export ELASTICSEARCH_HOST=node1

docker network create --driver overlay --attachable elastic
docker stack deploy --compose-file docker-compose.yml elastic
