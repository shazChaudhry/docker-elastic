#!/bin/bash

ELASTIC_VERSION=5.6.3 docker stack deploy -c docker-compose.yml elastic
