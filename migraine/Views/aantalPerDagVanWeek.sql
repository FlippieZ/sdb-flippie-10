

-- =================================================================================
-- Create View template for Azure SQL Database and Azure SQL Data Warehouse Database
-- =================================================================================


CREATE VIEW [migraine].[aantalPerDagVanWeek] AS
SELECT TOP 20 orderCol, attrCol, [1] AS Jan, [2] AS Feb, [3] AS Mrt, [4] AS Apr, [5] AS Mei, [6] AS Jun, [7] AS Jul, [8] AS Aug
	,[9] AS Sep, [10] AS Okt, [11] AS Nov, [12] AS Dec
FROM (
	SELECT MONTH(datum) AS Maand
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
		SELECT MONTH([datum]) AS Maand
			  ,case [dag]
				when 'Zo' then 'Zondag'
				when 'Ma' then 'Maandag'
				when 'Di' then 'Dinsdag'
				when 'Wo' then 'Woensdag'
				when 'Do' then 'Donderdag'
				when 'Vr' then 'Vrijdag'
				when 'Za' then 'Zaterdag'
				else '-' end AS attrCol
			  ,datum
			  ,datepart(dw, datum) as orderCol
		  FROM [migraine].[registratie]
		  WHERE soort = 'Migraine'
) p
PIVOT (
	COUNT(datum)
	FOR Maand IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) pvt
ORDER BY orderCol

GO

