-- CASE STATEMENTS AND MORE

/*SELECT wind_speed
FROM station_data
ORDER BY 1 DESC */

--SELECT report_code, wind_speed, CASE WHEN wind_speed >=40 THEN 'HIGH' WHEN wind_speed >=30 AND wind_speed <= 40 THEN 'MODERATE'ELSE 'lOW'END AS wind_severity,COUNT(*) AS record_count FROM station_data ORDER BY 3

--The Zero/Null trick

/*SELECT year, month, tornado, precipitation,
SUM(CASE WHEN tornado THEN precipitation ELSE 0 END) AS precipitation_frm_tornado,
SUM(CASE WHEN tornado = 0 THEN precipitation ELSE 0 END) AS just_precipitation
FROM station_data
GROUP BY 1, 2
ORDER BY 1 DESC*/

SELECT year, month, tornado, precipitation,
MAX(CASE WHEN tornado THEN precipitation ELSE NULL END) AS max_tornado_precipitation,
MAX(CASE WHEN tornado = 0 THEN precipitation ELSE NULL END) AS max_precipitation_alone
GROUP BY 1, 2
ORDER BY 1 DESC

