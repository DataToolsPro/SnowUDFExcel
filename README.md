# SnowUDFExcel
Snowflake UDF Functions modeled after Microsoft Excel functions

<H1>Background</H1>
This public repo was created to help analysts deploy familiar Excel function capabilities into Snowflake. Currently we have ported the following functions as JavaScript based functions:

<h2>WORKDAY</h2>

This is a Snowflake UDF (User-Defined Function)is intended to mimic the Excel WORKDAY function.. The function takes three inputs:
<p>
<b>START_DATE:</b> a date type input which represents the starting date.
<br/><b>DAYS:</b> a varchar(10) input that represents the number of workdays to be added to the start date.
<br/><b>HOLIDAYS:</b> a variant input that represents the holidays that are to be excluded while calculating the workdays.
</p>
<p><b>HOLIDAYS Table</b> This UDF was designed under an assumption there is a HOLDIAYS table located within the same schema where the UDF is deployed. Please see instructions below for installing the HOLIDAYS table
</p>
<p><b>Documentation</b>
The function is written in JavaScript and it first converts the input "HOLIDAYS" into a set of holidays, so that it can be easily checked if a date is a holiday or not. Then it initializes a variable "days_int" with the value of "DAYS" and converts it into an integer.
<br/>The function then starts a loop that runs until the "days_int" is greater than 0. In each iteration, it increases the date by 1 and checks if the current date is a weekend(Saturday or Sunday) or a holiday. If it is, it continues to the next iteration, otherwise it decrements the "days_int" by 1.
The function returns the final date after the loop is completed.
<p>
Please note that this UDF is based on the standard JavaScript Date object, which means it's based on the local timezone. Therefore, the result may vary depending on the timezone the Snowflake is running.</p>

<h2>NETWORKDAYS</h2>

<h2>NETWORKWEEKS - Expermintal</h2>
Technically, there is no Excel function for NETWORKWEEKs

These fun


