
-- =================================================================================
-- Create View template for Azure SQL Database and Azure SQL Data Warehouse Database
-- =================================================================================

CREATE VIEW [migraine].[aantalWeekDagPerMaand] AS
SELECT TOP 30 Jaar, orderCol, attrCol, [1] AS Jan, [2] AS Feb, [3] AS Mrt, [4] AS Apr, [5] AS Mei, [6] AS Jun, [7] AS Jul, [8] AS Aug
	,[9] AS Sep, [10] AS Okt, [11] AS Nov, [12] AS Dec
FROM (
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
) p
PIVOT (
	COUNT(datum)
	FOR Maand IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) pvtMigraine

GO

