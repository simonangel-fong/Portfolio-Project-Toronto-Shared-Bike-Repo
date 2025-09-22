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

-- Show current database and user
DELETE FROM dw_schema.staging_trip
WHERE trip_id = 'NULL'
   OR trip_duration = 'NULL'
   OR start_time = 'NULL'
   OR start_station_id = 'NULL'
   OR end_station_id = 'NULL';
