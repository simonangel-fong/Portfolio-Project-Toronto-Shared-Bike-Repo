-- ============================================================================
-- Script Name : transform.sql
-- Purpose     : Transform staging data.
-- Author      : Wenhao Fang
-- Date        : 2025-07-15
-- User        : Execute as a PostgreSQL superuser
-- ============================================================================

-- Enable verbose error reporting
\set ON_ERROR_STOP on

-- Connect to the toronto_shared_bike database
\c toronto_shared_bike;

\echo 
\echo '##################################################'
\echo 'Remove rows with NULLs in key columns... '
\echo '##################################################'
\echo 

DELETE FROM dw_schema.staging_trip
WHERE trip_id = 'NULL'
   OR trip_duration = 'NULL'
   OR start_time = 'NULL'
   OR start_station_id = 'NULL'
   OR end_station_id = 'NULL';

\echo '#######################'
DELETE FROM dw_schema.staging_trip
WHERE NOT trip_id ~ '^[0-9]+$'
   OR NOT trip_duration ~ '^[0-9]+(\.[0-9]+)?$'
   OR NOT start_time ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4} [0-9]{2}:[0-9]{2}$'
   OR TO_TIMESTAMP(start_time, 'MM/DD/YYYY HH24:MI') IS NULL
   OR NOT start_station_id ~ '^[0-9]+$'
   OR NOT end_station_id ~ '^[0-9]+$';