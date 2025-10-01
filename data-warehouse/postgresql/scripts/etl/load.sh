#!/usr/bin/bash

# ============================================================================
# Script Name : load.sh
# Purpose     : Load transformed data into data warehouse.
# Author      : Wenhao Fang
# Date        : 2025-07-15
# User        : Execute as a PostgreSQL superuser
# ============================================================================

set -e

DB_USER=postgres
DB_NAME=toronto_shared_bike
SQL_FILE=/scripts/etl/load.sql
LOG_FILE=/var/log/postgresql/etl_load.log

echo
echo "##############################"
echo "ETL Loading Task ..."
echo "##############################"
echo

psql -U $DB_USER \
    -d $DB_NAME \
    -L $LOG_FILE \
    -f $SQL_FILE

# echo
# echo "##############################"
# echo "Confirm ..."
# echo "##############################"
# echo

# psql -U "$DB_USER" -d "$DB_NAME" -L $LOG_FILE -c "SELECT COUNT(*) AS dim_time_count FROM dw_schema.dim_time;"
# psql -U "$DB_USER" -d "$DB_NAME" -L $LOG_FILE -c "SELECT COUNT(*) AS dim_station_count FROM dw_schema.dim_station;"
# psql -U "$DB_USER" -d "$DB_NAME" -L $LOG_FILE -c "SELECT COUNT(*) AS dim_bike_count FROM dw_schema.dim_bike;"
# psql -U "$DB_USER" -d "$DB_NAME" -L $LOG_FILE -c "SELECT COUNT(*) AS dim_user_type_count FROM dw_schema.dim_user_type;"
# psql -U "$DB_USER" -d "$DB_NAME" -L $LOG_FILE -c "SELECT COUNT(*) AS fact_trip_count FROM dw_schema.fact_trip;"
