#!/usr/bin/bash

set -euxo pipefail

DATA_DIR="data-warehouse/postgresql/raw"
URL_LIST=(
    "https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/Ridership-2019-Q1.csv"
    "https://toronto-shared-bike-data-warehouse-data-bucket.s3.ca-central-1.amazonaws.com/raw/Ridership-2019-Q2.csv"
)

echo
echo "##############################"
echo "Download csv files ..."
echo "##############################"
echo

pwd
ls
ls -l "${DATA_DIR}"
mkdir -pv "${DATA_DIR}"

for URL in "${URL_LIST[@]}";
do
    fname="$(basename "${URL}")"
    curl -f -L -S "${URL}" -o "${DATA_DIR}/${fname}"
    # sanity check
    test -s "${DATA_DIR}/${fname}"
done
