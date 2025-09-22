#!/usr/bin/bash

set -euxo pipefail

DATA_DIR="/data"
ZIP_FILE="csv.zip"

sudo mkdir -pv $DATA_DIR

sudo curl -o $DATA_DIR/$ZIP_FILE https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/data.zip
sudo curl -o /data/csv.zip https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/data.zip

sudo unzip $DATA_DIR/$ZIP_FILE -d /
sudo rm $DATA_DIR/$ZIP_FILE

sudo chown -R jenkins:jenkins $DATA_DIR

