CREATE OR REPLACE FUNCTION workday(START_DATE DATE, DAYS VARCHAR(10), HOLIDAYS VARCHAR(1000000))
RETURNS DATE
LANGUAGE JAVASCRIPT
AS $$
    // Convert the START_DATE to a JavaScript Date object
    var curr_date = new Date(START_DATE.getTime());

    // Split the HOLIDAYS string by commas into an array
    // Then create a Set from the array for faster lookup
    var holiday_list = HOLIDAYS.split(',');
    var holiday_set = new Set(holiday_list);

    // Convert the DAYS string to a number
    var days_int = Number(DAYS);

    // Decide if we should increment or decrement the date
    // We will increment if DAYS is positive and decrement if it's negative
    var increment = days_int >= 0 ? 1 : -1;

    // Convert days_int to its absolute value to handle the while loop correctly for both positive and negative cases
    days_int = Math.abs(days_int);

    // Continue adding or subtracting days until we have reached the desired number of workdays
    while(days_int > 0) {
        curr_date.setDate(curr_date.getDate() + increment);

        // Check if the current day is a weekday and not a holiday
        if (curr_date.getUTCDay() % 6 !== 0 && !holiday_set.has(curr_date.toString())) {
            // If it's a workday, decrease the counter
            days_int--;
        }
    }

    // Return the calculated date
    return curr_date;
$$;



