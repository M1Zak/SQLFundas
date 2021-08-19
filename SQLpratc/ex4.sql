--ex4
--1
/*SELECT * FROM STATION_DATA
WHERE year = 2010*/
--- we can use either != or <> to retrieve all weather data except from the year 2010.

--2
/*select * from station_data
where year between 2004 and 2008*/ --This is an inclusive range, as 2004 and '08 are included.

--3
--The above can also be done using, logical expressions
/*SELECT * 
FROM STATION_DATA
WHERE YEAR >= 2004 AND YEAR <=2008 */

--4
--We can also use OR operations
/*SELECT *
FROM STATION_DATA
WHERE MONTH = 3 OR MONTH = 6 OR MONTH = 9 OR MONTH = 12 */

--5
--The above can be more efficiently accomplished by using IN opeartor
--SELECT * FROM STATION_DATA WHERE MONTH IN(3,6,9)
-- Also, we can use NOT IN to exclude months or records not required for a particular query.

--6
--We can accomplish, the above again with a simple logic w/o the IN operator.
--SELECT * FROM STATION_DATA WHERE MONTH % 3 = 0 --This returns all the quarters without explicit specification.
--Note, Oracle does not support % operator, instead uses MOD() func.

--7
--We can use where operation with text, by specificing the text within single quotes.
--SELECT * FROM STATION_DATA WHERE report_code = '34DDA7' --NOTE 34DDA7, if not within quotes will be considered to be a number.

--8
--Other similar operations on text are: length(), IN('num', 'num1', 'num2')

--9
--One such operation is LIKE expression
--SELECT * FROM STATION_DATA WHERE report_code LIKE 'E%E' --Here the LIKE expression is used to find similar texts, while % is used as the wildcard
--Running this returns, a report_code starting with E as well as ending with E. This wildcard '%' is any number of characters.

--10
--Another similar wildcard is _ which is for any single character.
--SELECT * FROM STATION_DATA WHERE report_code LIKE 'E_3%' --This returns a code starting with E any character in between 3 and ending with any number of characters.

--11
--Using Boolean
--SELECT * FROM STATION_DATA WHERE thunder = 1 AND hail = 1 -- the columns here are of boolean values.

--12
--As columns are boolean, we can use implicit specification for true values.
--SELECT * FROM STATION_DATA WHERE thunder AND hail --this would return the same result as above

--13
--For specifying false, we will either specify as 0 or use NOT with WHERE
--sELECT * FROM STATION_DATA WHERE NOT rain AND hail --this would return all records with no rain but with hail recordings.

--14
--Handling nulls
--SELECT * FROM STATION_DATA WHERE precipitation IS NULL --Returns all values where precipitation is null. Here we see 
--precipitation is sometimes null, thus we need to either remove the nulls or always consider them when retrieving data with respect to precipitation, like.
--SELECT * FROM STATION_DATA WHERE precipitation <= 0.1 or precipitation IS NULL --This way, we can be sure that  no data is missed out, regardless of being null.

--15
--Now, to handle such nulls and avoid complexity, we use the Coalesce() func to change null to SOME value, that can be measured and manipulated.
--SELECT * FROM STATION_DATA WHERE coalesce(precipitation, 0) <= 0.1 --After this, we see all nulls in the columns has been changed to 0, which can be measured as a value.

--16
--Coalesce() can also be used in SELECT like all other functions.
/*SELECT report_code, coalesce(snow_depth, 0) as snowfall FROM STATION_DATA 
WHERE snowfall IS NOT NULL*/--this will change all nulls in snow_depth to 0 and also a new column with no nulls with name Snowfall
--And we use condition is not null to confirm this.



