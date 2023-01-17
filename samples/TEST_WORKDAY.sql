WITH holidays_array as (SELECT  ARRAY_TO_STRING(ARRAY_CONSTRUCT(
SELECT * FROM <DB_NAME>.<SCHEMA_NAME>.HOLIDAYS), ',') as HOLIDAYS)

SELECT WORKDAY('2023-01-09', '-60',(SELECT HOLIDAYS FROM holidays_array)) as workday