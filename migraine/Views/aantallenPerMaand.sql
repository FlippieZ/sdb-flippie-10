
CREATE   VIEW [migraine].[aantallenPerMaand] AS
SELECT *
FROM (
	SELECT * FROM migraine.aantalWeekDagPerMaand
	UNION
	SELECT * FROM migraine.aantalDagDeelPerMaand
	UNION
	SELECT * FROM migraine.aantalLocatiePerMaand
	UNION
	SELECT * FROM migraine.aantalMigrainePerMaand
    UNION
    SELECT * FROM [migraine].[aantalLichteMigrainePerMaand]
	UNION
	SELECT * FROM migraine.aantalHoofdpijnPerMaand
	UNION
	SELECT * FROM migraine.aantalTotaalUitvalPerMaand
	UNION
	SELECT * FROM migraine.aantalTriptaanPerMaand
	UNION
	SELECT * FROM migraine.aantalRecurrencePerMaand
) u

GO

