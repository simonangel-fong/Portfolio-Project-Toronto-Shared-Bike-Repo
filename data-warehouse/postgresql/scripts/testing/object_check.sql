SELECT EXISTS (
    SELECT 1
    FROM information_schema.schemata
    WHERE schema_name = 'dw_schema1'
);

-- SELECT COUNT(*)
-- FROM information_schema.tables
-- WHERE table_schema = 'dw_schema' -- Replace 'public' with your schema name if different
-- AND table_name = 'staging_trip'; -- Replace 'your_table_name' with the actual table name