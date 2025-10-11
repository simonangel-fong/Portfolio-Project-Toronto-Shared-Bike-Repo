#!/usr/bin/bash

set -e

DB_USER=postgres
DB_NAME=toronto_shared_bike
SQL_FILE=/scripts/testing/object_check.sql

psql -U $DB_USER \
    -d $DB_NAME \
    -c "SELECT * FROM information_schema.schemata WHERE schema_name = 'dw_schema1'"