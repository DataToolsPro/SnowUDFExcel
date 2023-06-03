CREATE OR REPLACE FUNCTION networkdays(START_DATE DATE, END_DATE DATE, HOLIDAYS VARCHAR(1000000))
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS $$
    // Check for null input and return null if any argument is null
    if(START_DATE == null || END_DATE == null || HOLIDAYS == null){
        return null;
    }
    
    // Convert the START_DATE and END_DATE to JavaScript Date objects
    var start_date = new Date(START_DATE);
    var end_date = new Date(END_DATE);

    // Split the HOLIDAYS string by commas into an array
    var holidays_list = HOLIDAYS.split(',');

    // Initialize a counter for the number of workdays
    var days_int = 0;

    // Initialize a variable to determine if we should increment or decrement the workday count
    // By default, we will increment the count
    var increment = 1;

    // If end_date is before start_date, swap them and set increment to -1 to decrement the workday count
    if(end_date < start_date){
        var temp_date = start_date;
        start_date = end_date;
        end_date = temp_date;
        increment = -1;
    }

    // Function to format dates as 'YYYY-MM-DD' to match with holidays list
    function formatDate(d) {
        var month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;

        return [year, month, day].join('-');
    }

    // Iterate through each date between start_date and end_date
    for(var curr_date = start_date; curr_date <= end_date; curr_date.setDate(curr_date.getDate()+1)) {
        var curr_date_str = formatDate(curr_date);
        
        // If the current day is a weekday and not a holiday, increment or decrement the workday count
        if(curr_date.getUTCDay() % 6 !== 0 && !holidays_list.includes(curr_date_str)) {
            days_int += increment;
        }
    }

    // Return the workday count
    return days_int;
$$;
