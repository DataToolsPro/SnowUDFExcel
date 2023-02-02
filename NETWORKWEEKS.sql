CREATE OR REPLACE FUNCTION networkweeks(START_DATE DATE, END_DATE DATE, HOLIDAYS VARCHAR(1000000))
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS $$
    // Check for null inputs
    if (START_DATE == null || END_DATE == null || HOLIDAYS == null) {
        return null;
    }
    // Split holidays into array
    var holidays_list = HOLIDAYS.split(',');
    var holiday_set = new Set(holidays_list);

    // Start counting from start date
    var curr_date = new Date(START_DATE);

    // End counting on end date
    var end_date = new Date(END_DATE);

    var weeks_int = 0;

    // Iterate through each day until end date
    while (curr_date <= end_date) {
        // Ignore weekends and holidays
        if (curr_date.getUTCDay() % 6 != 0 && !holiday_set.has(curr_date.toString())) {
            var next_date = new Date(curr_date.getTime());
            next_date.setDate(next_date.getDate() + 7);
            // Check if the next week is fully contained within the start and end dates
            if (next_date > end_date) {
                break;
            }
            // Increment the number of full weeks
            weeks_int++;
            curr_date = next_date;
        } else {
            curr_date.setDate(curr_date.getDate() + 1);
        }
    }

    return weeks_int;
$$;
