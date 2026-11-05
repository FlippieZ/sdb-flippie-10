
CREATE VIEW [migraine].[v_aantallen_per_maand] AS
	SELECT Jaar, mndNr, [1] AS Zondag, [2] AS Maandag, [3] AS Dinsdag, [4] AS Woensdag, [5] AS Donderdag, [6] AS Vrijdag, [7] AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM (
		SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr, DATEPART(dw, datum) AS Dag, COUNT(*) AS aantal
		FROM migraine.registratie
		WHERE soort IN ('Migraine', 'Lichte migraine')
		GROUP BY YEAR(datum), MONTH(datum), DATEPART(dw, datum)
	) p
	PIVOT (
		SUM(aantal)
		FOR Dag in ([1], [2], [3], [4], [5], [6], [7])
	) pvt
	UNION
	SELECT Jaar, mndNr, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, [Nacht] AS Nacht, [Ochtend] AS Ochtend, [Middag] AS Middag, [Avond] AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM (
		SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr, dagdeel, COUNT(*) AS aantal
		FROM migraine.registratie
		WHERE soort IN ('Migraine', 'Lichte migraine')
		GROUP BY YEAR(datum), MONTH(datum), dagdeel
	) p
	PIVOT (
		SUM(aantal)
		FOR dagdeel in ([Nacht], [Ochtend], [Middag], [Avond])
	) pvt
	UNION
	SELECT Jaar, mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, [Links] AS Links, [Rechts] AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM (
		SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr, locatie, COUNT(*) AS aantal
		FROM migraine.registratie
		WHERE soort IN ('Migraine', 'Lichte migraine')
			AND locatie IN ('Links', 'Rechts')
		GROUP BY YEAR(datum), MONTH(datum), locatie
	) p
	PIVOT (
		SUM(aantal)
		FOR locatie in ([Links], [Rechts])
	) pvt
	UNION
	SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, COUNT(*) AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM migraine.registratie
	WHERE soort = 'Migraine'
	GROUP BY YEAR(datum), MONTH(datum)
	UNION
	SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , COUNT(*) AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM migraine.registratie
	WHERE soort = 'Lichte migraine'
	GROUP BY YEAR(datum), MONTH(datum)
	UNION
	SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, COUNT(*) AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM migraine.registratie
	WHERE soort = 'Hoofdpijn'
	GROUP BY YEAR(datum), MONTH(datum)
	UNION
	SELECT YEAR(datum) AS Jaar, MONTH(datum) AS mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, COUNT(*) AS [Totaal uitval]
		, 0 AS Recurrence
		, 0 AS Triptaan
	FROM migraine.registratie
	WHERE soort IN ('Migraine', 'hoofdpijn', 'Lichte migraine')
	GROUP BY YEAR(datum), MONTH(datum)
	UNION
	SELECT YEAR(datum), MONTH(datum) AS mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, COUNT(*) AS Recurrence
		, 0 AS Triptaan
	FROM migraine.registratie
	WHERE recurrence = 'Ja'
	GROUP BY YEAR(datum), MONTH(datum)
	UNION
	SELECT YEAR(datum), MONTH(datum) AS mndNr
		, 0 AS Zondag, 0 AS Maandag, 0 AS Dinsdag, 0 AS Woensdag, 0 AS Donderdag, 0 AS Vrijdag, 0 AS Zaterdag
		, 0 AS Nacht, 0 AS Ochtend, 0 AS Middag, 0 AS Avond
		, 0 AS Links, 0 AS Rechts
		, 0 AS Migraine
        , 0 AS [Lichte migraine]
		, 0 AS Hoofdpijn
		, 0 AS [Totaal uitval]
		, 0 AS Recurrence
		, COUNT(*) AS Triptaan
	FROM migraine.registratie
	WHERE medicatie_genomen = 'Ja'
	GROUP BY YEAR(datum), MONTH(datum)

GO

