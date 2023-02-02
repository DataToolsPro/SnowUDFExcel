CREATE OR REPLACE FUNCTION workday(START_DATE DATE, DAYS VARCHAR(10), HOLIDAYS VARCHAR(1000000))
RETURNS DATE
LANGUAGE JAVASCRIPT
AS $$
    var curr_date = new Date(START_DATE.getTime());
    var holiday_list = HOLIDAYS.split(',');
    var holiday_set = new Set(holiday_list);
    var days_int = Number(DAYS);
    while(days_int > 0) {
        curr_date.setDate(curr_date.getDate() + 1);
        if (curr_date.getUTCDay() % 6 == 0 || holiday_set.has(curr_date.toString())) {
            continue;
        }
        days_int--;
    }
    return curr_date;
$$;


