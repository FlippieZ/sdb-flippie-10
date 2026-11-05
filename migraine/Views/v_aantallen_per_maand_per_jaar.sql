
CREATE VIEW [migraine].[v_aantallen_per_maand_per_jaar] AS
SELECT Jaar, u.mndNr AS orderCol, m.mndNaam AS Maand, SUM(Zondag) AS Zondag, SUM(Maandag) AS Maandag, SUM(Dinsdag) AS Dinsdag, SUM(Woensdag) AS Woensdag
	, SUM(Donderdag) AS Donderdag, SUM(Vrijdag) AS Vrijdag, SUM(Zaterdag) AS Zaterdag
	, SUM(Nacht) AS Nacht, SUM(Ochtend) AS Ochtend, SUM(Middag) AS Middag, SUM(Avond) AS Avond
	, SUM(Links) AS Links, SUM(Rechts) AS Rechts
	, SUM(Migraine) AS Migraine
    , SUM([Lichte migraine]) AS [Lichte migraine]
	, SUM(Hoofdpijn) AS Hoofdpijn
	, SUM([Totaal uitval]) AS [Totaal uitval]
	, SUM(Recurrence) AS Recurrence
	, SUM(Triptaan) AS Triptaan
FROM migraine.v_aantallen_per_maand u
INNER JOIN migraine.v_maanden m ON u.mndNr = m.mndNr
GROUP BY u.Jaar, u.mndNr, m.mndNaam
UNION
SELECT Jaar, 0 AS orderCol, 'Totaal' AS Maand
	, SUM(Zondag) AS Zondag, SUM(Maandag) AS Maandag, SUM(Dinsdag) AS Dinsdag, SUM(Woensdag) AS Woensdag
	, SUM(Donderdag) AS Donderdag, SUM(Vrijdag) AS Vrijdag, SUM(Zaterdag) AS Zaterdag
	, SUM(Nacht) AS Nacht, SUM(Ochtend) AS Ochtend, SUM(Middag) AS Middag, SUM(Avond) AS Avond
	, SUM(Links) AS Links, SUM(Rechts) AS Rechts
	, SUM(Migraine) AS Migraine
    , SUM([Lichte migraine]) AS [Lichte migraine]
	, SUM(Hoofdpijn) AS Hoofdpijn
	, SUM([Totaal uitval]) AS [Totaal uitval]
	, SUM(Recurrence) AS Recurrence
	, SUM(Triptaan) AS Triptaan
FROM migraine.v_aantallen_per_maand
GROUP BY Jaar

GO

