#!/usr/bin/bash

set -e

DB_USER=postgres
DB_NAME=toronto_shared_bike
FILE_PATH=/scripts/testing/object_check.sql

psql -U $DB_USER -d $DB_NAME -f /scripts/testing/object_check.sql