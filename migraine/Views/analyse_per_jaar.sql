
CREATE VIEW [migraine].[analyse_per_jaar] AS
WITH dij AS (
	SELECT DISTINCT YEAR(datum) AS jaar
		, DATEDIFF(d, DATEFROMPARTS(YEAR(datum), 1, 1), DATEFROMPARTS(YEAR(datum), 12, 31)) + 1 AS dagen_in_jaar
	FROM migraine.registratie
),
ld AS (
    SELECT YEAR(datum) AS jaar
        , CAST(COUNT(*) AS decimal(12, 5)) AS lichte_migraine_dagen
    FROM migraine.registratie r
    WHERE 1=1
        AND soort = 'Lichte migraine'
    GROUP BY YEAR(datum)
),
md AS (
	SELECT YEAR(datum) AS jaar
		, CAST(COUNT(*) AS decimal(12, 5)) AS migraine_dagen
	FROM migraine.registratie r
	WHERE 1=1
		AND soort = 'Migraine'
	GROUP BY YEAR(datum)
),
od AS (
	SELECT YEAR(datum) AS jaar
		, CAST(COUNT(*) AS decimal(12, 5)) AS hoofdpijn_dagen
	FROM migraine.registratie r
	WHERE 1=1
		AND soort = 'hoofdpijn'
	GROUP BY YEAR(datum)
),
td AS (
	SELECT YEAR(datum) AS jaar
		, CAST(COUNT(*) AS decimal(12, 5)) AS medicatie_genomen
	FROM migraine.registratie r
	WHERE 1=1
		AND soort = 'Migraine'
		AND medicatie_genomen = 'Ja'
	GROUP BY YEAR(datum)
),
rd AS (
	SELECT YEAR(datum) AS jaar
		, CAST(COUNT(*) AS decimal(12, 5)) AS recurrence_dagen
	FROM migraine.registratie r
	WHERE 1=1
		AND recurrence = 'Ja'
	GROUP BY YEAR(datum)
),
ja AS (
	SELECT dij.jaar
		, md.migraine_dagen AS migraine_dagen
		, md.migraine_dagen / 12 AS migraine_dagen_per_maand
		, md.migraine_dagen / dij.dagen_in_jaar * 100 AS migraine_dagen_gemiddeld
        , ld.lichte_migraine_dagen AS lichte_migraine_dagen
        , ld.lichte_migraine_dagen / 12 AS lichte_migraine_dagen_per_maand
        , ld.lichte_migraine_dagen / dij.dagen_in_jaar * 100 AS lichte_migraine_dagen_gemiddeld
		, (md.migraine_dagen + od.hoofdpijn_dagen + COALESCE(ld.lichte_migraine_dagen, 0)) AS totale_uitval
		, (md.migraine_dagen + od.hoofdpijn_dagen + COALESCE(ld.lichte_migraine_dagen, 0)) / 12 AS totale_uitval_per_maand
		, (md.migraine_dagen + od.hoofdpijn_dagen + COALESCE(ld.lichte_migraine_dagen, 0)) / dij.dagen_in_jaar * 100 AS totale_uitval_gemiddeld
		, td.medicatie_genomen
		, td.medicatie_genomen / 12 AS medicatie_genomen_per_maand
		, td.medicatie_genomen / dij.dagen_in_jaar * 100 AS medicatie_genomen_gemiddeld
		, rd.recurrence_dagen / md.migraine_dagen * 100 AS recurrence_tov_migraine
	FROM dij
    LEFT OUTER JOIN ld ON dij.jaar = ld.jaar
	LEFT OUTER JOIN md ON dij.jaar = md.jaar
	LEFT OUTER JOIN od ON dij.jaar = od.jaar
	LEFT OUTER JOIN td ON dij.jaar = td.jaar
	LEFT OUTER JOIN rd ON dij.jaar = rd.jaar
)
SELECT jaar, analyse, waarde
FROM (
	SELECT jaar
		, CAST(migraine_dagen AS decimal(12, 5)) AS [migraine/jaar]
		, CAST(migraine_dagen_per_maand AS decimal(12, 5)) AS [migraine/maand]
		, CAST(migraine_dagen_gemiddeld AS decimal(12, 5)) AS [migraine/jaar gemiddeld (%)]
        , CAST(lichte_migraine_dagen AS decimal(12, 5)) AS [lichte migraine/jaar]
		, CAST(lichte_migraine_dagen_per_maand AS decimal(12, 5)) AS [lichte migraine/maand]
		, CAST(lichte_migraine_dagen_gemiddeld AS decimal(12, 5)) AS [lichte migraine/jaar gemiddeld (%)]
		, CAST(totale_uitval AS decimal(12, 5)) AS [totale uitval/jaar]
		, CAST(totale_uitval_per_maand AS decimal(12, 5)) AS [totale uitval/maand]
		, CAST(totale_uitval_gemiddeld AS decimal(12, 5)) AS [totale uitval/jaar gemiddeld (%)]
		, CAST(medicatie_genomen AS decimal(12, 5)) AS [medicatie/jaar]
		, CAST(medicatie_genomen_per_maand AS decimal(12, 5)) AS [medicatie/maand]
		, CAST(medicatie_genomen_gemiddeld AS decimal(12, 5)) AS [medicatie/jaar gemiddeld (%)]
		, CAST(recurrence_tov_migraine AS decimal(12, 5)) AS [recurrence tov migraine (%)]
	FROM ja
) j
UNPIVOT 
	(waarde FOR analyse IN ([migraine/jaar], [migraine/maand], [migraine/jaar gemiddeld (%)]
        , [lichte migraine/jaar], [lichte migraine/maand], [lichte migraine/jaar gemiddeld (%)]
		, [totale uitval/jaar], [totale uitval/maand], [totale uitval/jaar gemiddeld (%)]
		, [medicatie/jaar], [medicatie/maand], [medicatie/jaar gemiddeld (%)]
		, [recurrence tov migraine (%)])
) AS p;

GO

