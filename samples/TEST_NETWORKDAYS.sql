WITH holidays_array as (SELECT  ARRAY_TO_STRING(ARRAY_CONSTRUCT(
SELECT * FROM <DB_NAME>.<SCHEMA_NAME>.HOLIDAYS), ',') as HOLIDAYS)

SELECT NETWORKDAYS('2023-01-10' , '2022-12-20' , (SELECT HOLIDAYS FROM holidays_array)) as networkdays