


-- =================================================================================
-- Create View template for Azure SQL Database and Azure SQL Data Warehouse Database
-- =================================================================================


CREATE VIEW [migraine].[aantallenPerMaandPerJaar] AS
SELECT TOP 30 Jaar, orderCol, attrCol, [1] AS Jan, [2] AS Feb, [3] AS Mrt, [4] AS Apr, [5] AS Mei, [6] AS Jun, [7] AS Jul, [8] AS Aug
	,[9] AS Sep, [10] AS Okt, [11] AS Nov, [12] AS Dec
FROM (
	SELECT MONTH(datum) AS Maand
		,YEAR(datum) AS Jaar
		,dagdeel AS attrCol
		,datum
		,case dagdeel
			when 'Nacht' then 8
			when 'Ochtend' then 9
			when 'Middag' then 10
			when 'Avond' then 11
			else 0 end AS orderCol
	FROM migraine.registratie
	WHERE soort = 'migraine'
	UNION
	SELECT MONTH(datum) AS Maand
		,YEAR(datum) AS Jaar
		,locatie AS attrCol
		,datum
		,case locatie
			when 'Links' then 12
			when 'Rechts' then 13
			when 'Locatie onbekend' then 14
			else 0 end AS orderCol
	FROM migraine.registratie
	WHERE soort = 'migraine'
	UNION
	SELECT MONTH([datum]) AS Maand
		,YEAR(datum) AS Jaar
		,CASE DATEPART(dw, datum)
			WHEN 1 THEN 'Zondag'
			WHEN 2 THEN 'Maandag'
			WHEN 3 THEN 'Dinsdag'
			WHEN 4 THEN 'Woensdag'
			WHEN 5 THEN 'Donderdag'
			WHEN 6 THEN 'Vrijdag'
			WHEN 7 THEN 'Zaterdag'
			ELSE '-' END AS attrCol
		,datum
		,datepart(dw, datum) as orderCol
	FROM [migraine].[registratie]
	WHERE soort = 'Migraine'
	UNION
	SELECT MONTH([datum]) AS Maand
		,YEAR(datum) AS Jaar
		,'Migraine dagen' AS attrCol
		,datum
		,15 AS orderCol
	FROM migraine.registratie
	WHERE soort = 'migraine'
	UNION
	SELECT MONTH([datum]) AS Maand
		,YEAR(datum) AS Jaar
		,'Hoofdpijn dagen' AS attrCol
		,datum
		,16 AS orderCol
	FROM migraine.registratie
	WHERE soort = 'hoofdpijn'
	UNION
	SELECT MONTH([datum]) AS Maand
		,YEAR(datum) AS Jaar
		,'Totale uitval' AS attrCol
		,datum
		,17 AS orderCol
	FROM migraine.registratie
	WHERE soort IN ('migraine', 'hoofdpijn')
	UNION
	SELECT MONTH([datum]) AS Maand
		,YEAR(datum) AS Jaar
		,'Triptaan' AS attrCol
		,datum
		,18 AS orderCol
	FROM migraine.registratie
	WHERE medicatie_genomen = 'ja'
	UNION
	SELECT MONTH([datum]) AS Maand
		,YEAR(datum) AS Jaar
		,'Recurrence' AS attrCol
		,datum
		,19 AS orderCol
	FROM migraine.registratie
	WHERE recurrence = 'ja'
	UNION
	SELECT MONTH(datum) AS Maand
		,YEAR(datum) AS Jaar
		,signaal AS attrCol
		,datum
		,case signaal
			when 'Doffe ogen' then 20
			when 'Geeuwen' then 21
			else 0 end AS orderCol
	FROM migraine.registratie
	WHERE soort = 'signaal'
	UNION
	SELECT MONTH(datum) AS Maand
		,YEAR(datum) AS Jaar
		,'Aantal aanvallen binnen 3 dagen na doffe ogen' AS attrCol
		,datum
		,22 AS orderCol
	FROM migraine.registratie mr
	WHERE soort = 'signaal'
		AND signaal = 'doffe ogen'
		AND 	
		(SELECT COUNT(1) 
		FROM migraine.registratie r 
		WHERE r.soort = 'migraine'
			AND mr.datum >= DATEADD(d, -3, r.datum)
			AND mr.datum <= r.datum) > 0 ) p
PIVOT (
	COUNT(datum)
	FOR Maand IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) pvt
ORDER BY orderCol

GO

