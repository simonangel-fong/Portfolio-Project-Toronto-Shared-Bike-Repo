#!/bin/bash

set -euo pipefail

DOCKER_FILE="data-warehouse/cloudflare/docker-compose.yaml"

echo
echo "##############################"
echo "Start up App"
echo "##############################"
echo

docker compose -f $DOCKER_FILE up -d