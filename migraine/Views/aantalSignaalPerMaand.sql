
-- =================================================================================
-- Create View template for Azure SQL Database and Azure SQL Data Warehouse Database
-- =================================================================================

CREATE VIEW [migraine].[aantalSignaalPerMaand] AS
SELECT TOP 30 Jaar, orderCol, attrCol, [1] AS Jan, [2] AS Feb, [3] AS Mrt, [4] AS Apr, [5] AS Mei, [6] AS Jun, [7] AS Jul, [8] AS Aug
	,[9] AS Sep, [10] AS Okt, [11] AS Nov, [12] AS Dec
FROM (
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
) p
PIVOT (
	COUNT(datum)
	FOR Maand IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) pvtMigraine

GO

