#!/usr/bin/bash

set -euo pipefail

DATA_DIR="/data"
ZIP_FILE="csv.zip"

echo
echo "##############################"
echo "Download csv zip"
echo "##############################"
echo
sudo mkdir -pv $DATA_DIR
sudo curl -o $DATA_DIR/$ZIP_FILE https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/data.zip

echo
echo "##############################"
echo "Unzip..."
echo "##############################"
echo
sudo unzip $DATA_DIR/$ZIP_FILE -d /
sudo rm $DATA_DIR/$ZIP_FILE

sudo chown -R jenkins:jenkins $DATA_DIR
