#!/bin/bash

ELASTIC_VERSION=5.4.0 docker stack deploy -c docker-compose.yml logging
