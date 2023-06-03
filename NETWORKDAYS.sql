CREATE OR REPLACE FUNCTION networkdays(START_DATE DATE, END_DATE DATE, HOLIDAYS VARCHAR(1000000))
RETURNS INT
LANGUAGE JAVASCRIPT
AS $$
    // Checking if any of the input parameters are null
    // If any parameter is null, the function returns null
    if(START_DATE == null || END_DATE == null || HOLIDAYS == null){
        return null;
    }

    // Creating JavaScript Date objects from the input parameters
    var start_date = new Date(START_DATE);
    var end_date = new Date(END_DATE);

    // Splitting the HOLIDAYS string by commas into an array
    // Then creating a Set from the array for faster lookup
    var holidays_list = HOLIDAYS.split(',');
    var holiday_set = new Set(holidays_list);

    // This will hold the count of working days
    var days_int = 0;

    // Function to format a date as 'yyyy-mm-dd'
    // This is needed for comparing dates in the loop
    function formatDate(d) {
        var month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        // Padding month and day with leading zeroes if needed
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;

        // Returning the formatted date string
        return [year, month, day].join('-');
    }

    // Looping from start_date to end_date
    for(var curr_date = start_date; curr_date <= end_date; curr_date.setDate(curr_date.getDate()+1)) {
        // Formatting curr_date as 'yyyy-mm-dd'
        var curr_date_str = formatDate(curr_date);
        
        // Checking if curr_date is not a weekend and not a holiday
        // If both conditions are true, increment days_int
        if(curr_date.getUTCDay() % 6 !== 0 && !holiday_set.has(curr_date_str)) {
            days_int++;
        }
    }

    // Returning the count of working days
    return days_int;
$$;
