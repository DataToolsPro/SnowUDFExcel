WITH holidays_array AS (
SELECT ARRAY_TO_STRING(ARRAY_AGG(to_char(HOLIDAY, 'YYYY-MM-DD')), ',') AS HOLIDAYS
FROM <DB_NAME>.<SCHEMA_NAME>.HOLIDAYS
)

SELECT NETWORKDAYS('2023-01-10' , '2022-12-20' , (SELECT HOLIDAYS FROM holidays_array)) as networkdays
