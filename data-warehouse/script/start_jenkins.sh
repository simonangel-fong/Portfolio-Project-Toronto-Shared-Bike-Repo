#!/bin/bash

set -euo pipefail

JENKINS_FILE="data-warehouse/jenkins/docker-compose.yaml"

echo
echo "##############################"
echo "Start up Prometheus"
echo "##############################"
echo

docker compose -f $JENKINS_FILE up -d