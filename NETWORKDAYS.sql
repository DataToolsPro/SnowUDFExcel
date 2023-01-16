--CREATED BY RYAN GOODMAN--

CREATE OR REPLACE FUNCTION networkdays(START_DATE DATE, END_DATE DATE, HOLIDAYS VARCHAR(1000000))
RETURNS VARCHAR(255)
LANGUAGE JAVASCRIPT
AS $$
	// Check for null inputs
	if(START_DATE == null || END_DATE == null || HOLIDAYS == null){
        return null;
    }
   
	var start_date = START_DATE;
	var end_date = END_DATE;

    // Split holidays into array
	var holidays_list = HOLIDAYS.split(',');
	var holiday_set = new Set(holidays_list);

	var days_int = 0;
	var isNegative = false;
	
	// Check if end_date is before start_date
	if(end_date < start_date){
	var temp_date = start_date;
	start_date = end_date;
	end_date = temp_date;
	isNegative = true;
	}
	
	for(var curr_date = start_date; curr_date <= end_date; curr_date.setDate(curr_date.getDate()+1)) {
	if(curr_date.getUTCDay() % 6 == 0 || holiday_set.has(curr_date.toString())) {
	continue;
	}
	days_int++;
	}
	if(isNegative) return -days_int;
	
	return days_int;
$$;