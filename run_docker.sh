#!/usr/bin/env bash

#export DOCKER_KAFKA_HOST=$(ipconfig getifaddr en0)
#export DOCKER_KAFKA_HOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)

docker-compose -f docker-compose.yml up -d
