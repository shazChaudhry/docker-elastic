#!/bin/bash

ELASTIC_VERSION=6.0.0 docker stack deploy -c docker-compose.yml elastic
