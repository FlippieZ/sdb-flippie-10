-- =============================================
-- Description:	Verwerkt de nieuwste onverwerkte JSON-export uit
--				migraine.inbox_json naar migraine.registratie_json.
--				Elke export is volledig, dus de doeltabel wordt telkens
--				volledig ververst. Alle onverwerkte inbox-regels worden
--				daarna als verwerkt gemarkeerd.
-- =============================================
CREATE PROCEDURE [migraine].[verwerk_registraties_json]
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @id INT;
	DECLARE @registraties NVARCHAR (MAX);
	DECLARE @aantal_ongeldig INT;

	SELECT TOP 1 @id = id, @registraties = registraties
	FROM migraine.inbox_json
	WHERE verwerkt = 0
	ORDER BY datum DESC, id DESC;

	IF @id IS NULL
		RETURN;

	-- Controle vooraf: ontbrekende of onleesbare datums (formaat d-m-yyyy)
	SELECT @aantal_ongeldig = COUNT(*)
	FROM OPENJSON(@registraties)
	WITH (datum NVARCHAR (10) '$.Datum') AS j
	WHERE TRY_CONVERT(date, j.datum, 105) IS NULL;

	IF @aantal_ongeldig > 0
	BEGIN
		DECLARE @melding NVARCHAR (200) =
			CONCAT(N'inbox_json id ', @id, N': ', @aantal_ongeldig, N' registratie(s) met ontbrekende of ongeldige datum.');
		THROW 50001, @melding, 1;
	END

	BEGIN TRY
		BEGIN TRANSACTION;

		TRUNCATE TABLE migraine.registratie_json;

		-- JSON-paden zijn hoofdlettergevoelig en moeten exact overeenkomen
		-- met de veldnamen in de bron (inclusief de typfout "Medicate").
		INSERT INTO migraine.registratie_json (inbox_json_id, datum, dag, dagdeel, soort, signaal,
				recurrence, locatie, medicatie_genomen, medicatie, medicatie_tijd)
		SELECT @id, TRY_CONVERT(date, j.datum, 105), j.dag, j.dagdeel, j.soort, j.signaal,
				j.rebound, j.locatie, j.medicatie_genomen, j.medicatie, j.medicatie_tijd
		FROM OPENJSON(@registraties)
		WITH (
			datum             NVARCHAR (10) '$.Datum',
			dag               NVARCHAR (2)  '$.Dag',
			dagdeel           NVARCHAR (10) '$.Dagdeel',
			soort             NVARCHAR (20) '$.Soort',
			signaal           NVARCHAR (20) '$.Signaal',
			rebound           NVARCHAR (5)  '$.Rebound',
			locatie           NVARCHAR (20) '$.Locatie',
			medicatie_genomen NVARCHAR (5)  '$."Medicate genomen"',
			medicatie         NVARCHAR (30) '$.Medicatie',
			medicatie_tijd    NVARCHAR (10) '$."Medicate tijdstip"'
		) AS j;

		-- Oudere exports zijn achterhaald door de nieuwste
		UPDATE migraine.inbox_json
		SET verwerkt = 1,
			verwerkt_op = SYSDATETIME()
		WHERE verwerkt = 0;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END

GO

