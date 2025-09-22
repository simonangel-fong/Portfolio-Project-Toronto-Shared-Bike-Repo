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
SELECT 
	current_database() 	AS database_name
	, current_user 		AS username
;

SELECT 
	current_database() 	AS database_name
	, current_user 		AS username
;

SELECT 
	current_database() 	AS database_name
	, current_user 		AS username
;

