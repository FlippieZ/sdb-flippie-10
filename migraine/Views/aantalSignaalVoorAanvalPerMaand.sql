
-- =================================================================================
-- Create View template for Azure SQL Database and Azure SQL Data Warehouse Database
-- =================================================================================

CREATE VIEW [migraine].[aantalSignaalVoorAanvalPerMaand] AS
SELECT TOP 30 Jaar, orderCol, attrCol, [1] AS Jan, [2] AS Feb, [3] AS Mrt, [4] AS Apr, [5] AS Mei, [6] AS Jun, [7] AS Jul, [8] AS Aug
	,[9] AS Sep, [10] AS Okt, [11] AS Nov, [12] AS Dec
FROM (
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
) pvtMigraine

GO

