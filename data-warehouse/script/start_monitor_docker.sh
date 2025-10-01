#!/bin/bash

set -euo pipefail

PROMETHEUS_FILE="data-warehouse/monitor/docker-compose.yaml"

echo
echo "##############################"
echo "Start up Prometheus"
echo "##############################"
echo

docker compose -f $PROMETHEUS_FILE up -d