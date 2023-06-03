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
    
    // Create a set of holidays for easy access
    var holiday_set = new Set(holidays_list);

    // Start date for counting
    var curr_date = new Date(START_DATE);

    // End date for counting
    var end_date = new Date(END_DATE);

    // Initialize a variable to determine if we should increment or decrement the week count
    // By default, we will increment the count
    var increment = 1;

    // If end_date is before start_date, swap them and set increment to -1 to decrement the week count
    if(end_date < curr_date){
        var temp_date = curr_date;
        curr_date = end_date;
        end_date = temp_date;
        increment = -1;
    }

    // Counter for the number of weeks
    var weeks_int = 0;

    // Iterate through each day until end date
    while (curr_date <= end_date) {
        // If the current day is a weekday and not a holiday
        if (curr_date.getUTCDay() % 6 != 0 && !holiday_set.has(curr_date.toString())) {
            var next_date = new Date(curr_date.getTime());
            next_date.setDate(next_date.getDate() + 7); // Set the next_date to 7 days from curr_date
            
            // If the next week is beyond the end date, stop counting
            if (next_date > end_date) {
                break;
            }
            
            // Increment the number of full weeks
            weeks_int += increment;
            
            // Set the curr_date to the next_date for the next iteration
            curr_date = next_date;
        } else {
            // If it is a weekend or a holiday, just go to the next day
            curr_date.setDate(curr_date.getDate() + 1);
        }
    }

    // Return the number of full weeks
    return weeks_int;
$$;
