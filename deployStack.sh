#!/bin/bash

ELASTIC_VERSION=5.6.2 docker stack deploy -c docker-compose.yml elastic
