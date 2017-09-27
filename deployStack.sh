#!/bin/bash

ELASTIC_VERSION=5.6.1 docker stack deploy -c docker-compose.yml elastic
