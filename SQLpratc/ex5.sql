--ex5.sql

--SELECT INSTR('CAP AM', 'B') --Used to find the location of a text in a string, if querreid text is not present, it returns a zero. Thus the func. is one indexed.

--SELECT * FROM CUSTOMER WHERE STATE REGEXP '[A-Z]{2}' --no space btw ]{ for regular exp., returns all states with two cap literals.

--replace('tony am','tony','cap') --replaces the string with cap.

--substr('THREE',2,3) --returns the second and thrid literals of the string.

--count(city) --counts the number of non-null values

--SELECT DATE('now') --Gets todays date

--SELECT DATE('2021-12-03', '+4 Month', '+2 day') --One example of date transformation

--SELECT strftime('%d/%m/%Y', 'now') --Also, can be in %d-%m-%Y but note that there should be a cap Y.

--SELECT COUNT(*) AS Total FROM STATION_DATA --this will counts the total number of records in a table.

--SELECT COUNT(*) AS total_tornados FROM station_data WHERE tornado

--SELECT year FROM station_data GROUP BY year --Sorts year in an ascending order.

--SELECT year, COUNT(*) as tornado_count FROM station_data WHERE tornado AND year = 2001 --To get tornado stats from year 2001 only

--SELECT year, month, COUNT(*) as tornado_count FROM station_data WHERE tornado GROUP BY 1, 2 --To sort by year and tornado count

--SELECT year || '/' ||month as ym, COUNT(tornado) as tornado_count FROM station_data WHERE tornado GROUP BY year, month ORDER BY year DESC--Gives us the most recent recordings, ordered descendingly.

--SELECT year, month, round(AVG(temperature),2) AS avg_temp, round(SUM(snow_depth),2) AS snow_depth, SUM(precipitation) AS Sprecipitation, MAX(precipitation) AS Mprecipitation FROM station_data WHERE year >= 2003 GROUP BY year, month
--Here are a list of aggregate functions

/*SELECT year, SUM(precipitation) as t_precipitate, MAX(precipitation) AS m_precipitate
FROM station_data
WHERE tornado = 1
GROUP BY year
HAVING t_precipitate >= 3 */

--SELECT COUNT(*) as total_count FROM station_data

--SELECT DISTINCT station_number FROM station_data ORDER BY station_number DESC

/*SELECT year,
round(SUM(precipitation), 2) AS total_precipitation,
MAX(precipitation) AS max_precipitation
FROM station_data
WHERE year >= 2000
GROUP BY year
HAVING total_precipitation < 30 */

/*SELECT COUNT(*) AS count_hail
FROM station_data
WHERE tornado IN(1) AND hail IN (0) */
