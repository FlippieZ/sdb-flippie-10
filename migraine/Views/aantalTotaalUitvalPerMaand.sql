CREATE VIEW [migraine].[aantalTotaalUitvalPerMaand] AS
SELECT Jaar, 17 AS orderCol, 'Totale uitval' AS attrCol, SUM(Jan) AS Jan, SUM(Feb) AS Feb, SUM(Mrt) AS Mrt, SUM(Apr) AS Apr
	, SUM(Mei) AS Mei
	, SUM(Jun) AS Jun, SUM(Jul) AS Jul, SUM(Aug) AS Aug, SUM(Sep) AS Sep, SUM(Okt) AS Okt, SUM(Nov) AS Nov, SUM(Dec) AS [Dec] 
FROM (
	SELECT *
	FROM migraine.aantalMigrainePerMaand
	UNION 
    SELECT *
    FROM migraine.aantalLichteMigrainePerMaand
    UNION
	SELECT *
	FROM migraine.aantalHoofdpijnPerMaand
) u
GROUP BY Jaar

GO

