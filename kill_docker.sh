#!/usr/bin/env bash

export DOCKER_KAFKA_HOST=$(ipconfig getifaddr en0)

docker-compose -f docker-compose.yml down
