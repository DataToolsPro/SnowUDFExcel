--CREATED BY RYAN GOODMAN--

CREATE OR REPLACE FUNCTION networkweeks(START_DATE DATE, END_DATE DATE, HOLIDAYS VARCHAR(1000000))
RETURNS VARCHAR(255)
LANGUAGE JAVASCRIPT
AS $$
    // Check for null inputs
    if (START_DATE == null || END_DATE == null || HOLIDAYS == null) {
        return null;
    }
    // Split holidays into array
    var holidays_list = HOLIDAYS.split(',');
    var holiday_set = new Set(holidays_list);

    // Start counting from next Monday after start date
    var curr_date = new Date(START_DATE);
    curr_date.setDate(curr_date.getDate() + (8 - curr_date.getUTCDay()) % 7);

    // End counting on previous Friday before end date
    var end_date = new Date(END_DATE);
    end_date.setDate(end_date.getDate() - end_date.getUTCDay() % 7);

    var weeks_int = 0;

    // Iterate through each week until end date
    while (curr_date < end_date) {
        // Ignore weekends and holidays
        if (curr_date.getUTCDay() % 6 != 0 && !holiday_set.has(curr_date.toString())) {
            weeks_int++;
        }
        curr_date.setDate(curr_date.getDate() + 7);
    }

    return weeks_int;
$$;