# SnowUDFExcel
Snowflake UDF Functions modeled after Microsoft Excel functions

<H1>Background</H1>
This public repository was created to help analysts deploy familiar Excel function capabilities into Snowflake. Currently we have ported the following functions as JavaScript based functions:

<ul>
  <li><b>WORKDAY</b> function calculates the date after a given number of workdays, while excluding specified holidays</li>
  <li><b>NETWORKDAYS</b> function calculates the number of workdays between two given dates, while excluding specified holidays</li> 
  <li><b>NETWORKWEEKS</b> function calculates the number of network weeks between two given dates, while excluding specified holidays</li>
</ul>

<h3>Notes on HOLIDAYS table</h3>
To execute the functions in this repository in your Snowflake environment, it requires implementing a HOLIDAYS table within the schema for which the UDF is deployed. Please check out the WIKI for detailed instructions how to quickly install the HOLIDAYS table.

<p>The UDF functions in this repository for WEEKDAY, NETWORKDAYS, and WORKDAY were implemented to use a Snowflake table to acquire the Holidays that are skipped. This article describes how to install the HOLDIAYS Table:</p>
<ol>
<li>Download from the Samples folder the HOLDIAYS.SQL</li>
<li>In snowflake select the Table and Schema you want to add the holiday table. This should be the same schema where you are importing the UDF</li>
<li>Execute the TABLE CREATION and INSERT SQL to place holidays into the table.</li>
</ol>
The holidays data is available in a CSV format in the event you would like to add more holidays into your table.

<p>The holidays included with this code come from the Federal Reserve bank website:
<br/>https://www.frbservices.org/about/holiday-schedules</p>

<h2>WORKDAY UDF for Snowflake</h2>

This is a Snowflake UDF (User-Defined Function) mimics the Excel WORKDAY function input and results. It adds or subtracts the number of days from a single date and outputs the resulting date while excluding weekends and specified holidays. The function takes three inputs:
<p>
<b>START_DATE:</b> a date type input which represents the starting date.
<br/><b>DAYS:</b> a varchar(10) input that represents the number of workdays to be added to the start date.
<br/><b>HOLIDAYS:</b> a variant input that represents the holidays that are to be excluded while calculating the workdays.
</p>
<p><b>HOLIDAYS Table</b> This UDF was designed under an assumption there is a HOLDIAYS table located within the same schema where the UDF is deployed. Please see instructions below for installing the HOLIDAYS table
</p>
<p><b>Example SQL to Execute WORKDAY UDF</b>
  <br/><CODE>WITH holidays_array as (SELECT  ARRAY_TO_STRING(ARRAY_CONSTRUCT(
SELECT * FROM <DB_NAME>.<SCHEMA_NAME>.HOLIDAYS), ',') as HOLIDAYS)

SELECT WORKDAY('2023-01-09', '-60',(SELECT HOLIDAYS FROM holidays_array)) as networkday</CODE>
 </p>
<p><b>Documentation</b> 
<br/>The function is written in JavaScript and it first converts the input "HOLIDAYS" into a set of holidays, so that it can be easily checked if a date is a holiday or not. Then it initializes a variable "days_int" with the value of "DAYS" and converts it into an integer.
<br/>The function then starts a loop that runs until the "days_int" is greater than 0. In each iteration, it increases the date by 1 and checks if the current date is a weekend(Saturday or Sunday) or a holiday. If it is, it continues to the next iteration, otherwise it decrements the "days_int" by 1.
The function returns the final date after the loop is completed.
<p>
Please note that this UDF is based on the standard JavaScript Date object, which means it's based on the local timezone. Therefore, the result may vary depending on the timezone the Snowflake is running.</p>

<h2>NETWORKDAYS</h2>

This is a Snowflake UDF (User-Defined Function) mimics the Excel NETWORKDAYS function input and results. It calculates the number of network days between two given dates, while excluding weekends and specified holidays. The function takes three inputs:
<p>
  <b>START_DATE:</b> a date type input which represents the starting date.
<br/><b>END_DATE:</b> a date type input which represents the end date.
<br/><b>HOLIDAYS:</b> a varchar(1000000) input that represents the holidays that are to be excluded while calculating the network days. The holidays are passed in a string format, separated by commas.
 <p><b>HOLIDAYS Table</b> This UDF was designed under an assumption there is a HOLDIAYS table located within the same schema where the UDF is deployed. Please see instructions below for installing the HOLIDAYS table
</p>
 <p><b>Example SQL to Execute WORKDAY UDF</b>
  <br/><CODE>WITH holidays_array as (SELECT  ARRAY_TO_STRING(ARRAY_CONSTRUCT(
SELECT * FROM <DB_NAME>.<SCHEMA_NAME>.HOLIDAYS), ',') as HOLIDAYS)

SELECT NETWORKDAYS('2023-01-10' , '2022-12-20' , (SELECT HOLIDAYS FROM holidays_array)) as networkdays</CODE>
   </p>
<p><b>Documentation</b> 
<br/>The function is written in JavaScript and it first checks if any of the inputs are null, if so it returns null. Then it converts the input "HOLIDAYS" into a set of holidays, so that it can be easily checked if a date is a holiday or not.
<br/>The function then checks if the end date is before the start date, if so it swaps the values of start_date and end_date and sets the variable 'isNegative' to true to indicate that the result should be negative.
<br/>The function starts a loop that runs from the start date to the end date. In each iteration, it checks if the current date is a weekend(Saturday or Sunday) or a holiday. If it is, it continues to the next iteration, otherwise it increments the "days_int" by 1.
The function returns the final number of network days. If the start date was greater than the end date, the function returns a negative value.
<p>Please note that this UDF is based on the standard JavaScript Date object, which means it's based on the local timezone. Therefore, the result may vary depending on the timezone the Snowflake is running.

<h2>NETWORKWEEKS - Expermintal</h2>
Technically, there is no Excel function for NETWORKWEEKs. This is a Snowflake UDF (User-Defined Function) that calculates the number of network weeks between two given dates, while excluding specified holidays. The function takes three inputs:
<p>
<b>START_DATE:</b> a date type input which represents the starting date.
<br/><b>END_DATE:</b> a date type input which represents the end date.
<br/><b>HOLIDAYS:</b> a varchar(1000000) input that represents the holidays that are to be excluded while calculating the network weeks. The holidays are passed in a string format, separated by commas.
  <p><b>HOLIDAYS Table</b> This UDF was designed under an assumption there is a HOLDIAYS table located within the same schema where the UDF is deployed. Please see instructions below for installing the HOLIDAYS table
</p>
   <p><b>Example SQL to Execute WORKDAY UDF</b>
  <br/><CODE>WITH holidays_array as (SELECT  ARRAY_TO_STRING(ARRAY_CONSTRUCT(
SELECT * FROM <DB_NAME>.<SCHEMA_NAME>.HOLIDAYS), ',') as HOLIDAYS)

SELECT NETWORKWEEKS('2023-01-06' , '2023-01-16' , (SELECT HOLIDAYS FROM holidays_array)) as networkweeks</CODE>
     </p>
<p><b>Documentation</b> 
<br/>The function is written in JavaScript and it first checks if any of the inputs are null, if so it returns null. Then it converts the input "HOLIDAYS" into a set of holidays, so that it can be easily checked if a date is a holiday or not.
<br/>The function then sets the current date to the next Monday after the start date and sets the end date to the previous Friday before the end date.
<br/>The function starts a loop that runs until the current date is less than the end date. In each iteration, it checks if the current date is a weekend(Saturday or Sunday) or a holiday. If it is not, it increments the "weeks_int" by 1.
<br/>The function returns the final number of network weeks.
<p/>Please note that this UDF is based on the standard JavaScript Date object, which means it's based on the local timezone. Therefore, the result may vary depending on the timezone the Snowflake is running.






