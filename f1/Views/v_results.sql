CREATE VIEW f1.v_results AS
SELECT a.[year], CAST(a.round AS int) AS race, a.name AS [grand prix], a.[date], 
	i.name AS circuit, i.location, i.country,
	CONCAT(d.forename, ' ', d.surname) AS driver, d.nationality AS [nationality driver],
	c.name AS [constructor], c.nationality AS [nationality constructor],
	s.status,
	r.grid, r.[position], CAST(r.points AS float) AS points, race_type 
--,
--	CAST(CASE WHEN [year] >= 2010 
--			THEN points 
--			ELSE 
--				CASE position 
--					WHEN '1' THEN 25
--					WHEN '2' THEN 18
--					WHEN '3' THEN 15
--					WHEN '4' THEN 12
--					WHEN '5' THEN 10
--					WHEN '6' THEN 8
--					WHEN '7' THEN 6
--					WHEN '8' THEN 4
--					WHEN '9' THEN 2
--					WHEN '10' THEN 1
--					ELSE 0
--				END 
--		END AS float) AS points_2010
FROM (
	SELECT raceId, driverId, constructorId, grid, [position], points, statusId, 'GP' AS race_type 
	FROM f1.results 
	UNION
	SELECT raceId, driverId, constructorId, grid, [position], points, statusId, 'Sprint' AS race_type 
	FROM f1.sprint_results 
) r 
INNER JOIN f1.races a ON r.raceId = a.raceId 
INNER JOIN f1.circuits i ON a.circuitId = i.circuitId
INNER JOIN f1.drivers d ON r.driverId = d.driverId
INNER JOIN f1.constructors c ON r.constructorId = c.constructorId 
INNER JOIN f1.status s ON r.statusId = s.statusId

GO

