-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE migraine.verwerk_registratie 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @reg nvarchar(MAX);

	SET @reg = (SELECT TOP 1 SUBSTRING(registraties, CHARINDEX(CHAR(13), registraties), LEN(registraties)) 
					FROM migraine.inbox 
					WHERE verwerkt = 0);

	IF @reg IS NOT NULL
	BEGIN
		BEGIN TRANSACTION;

		TRUNCATE TABLE migraine.registratie;

		INSERT INTO migraine.registratie
		SELECT CONVERT(date, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 1, ';'), 105) AS datum
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 2, ';') AS dag 
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 3, ';') AS dagdeel 
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 4, ';') AS soort 
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 5, ';') AS signaal 
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 6, ';') AS rebound
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 7, ';') AS locatie
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 8, ';') AS medicatie_genomen
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 9, ';') AS medicatie
			, dbo.fnSEPARATES_COLUMNS(SUBSTRING(splitdata, CHARINDEX(CHAR(10),  splitdata) + 1, LEN(splitdata)), 10, ';') AS medicatie_tijdstip
		FROM dbo.fnSplitString(@reg, CHAR(13))
		WHERE LEN(splitdata) > 1;

		UPDATE migraine.inbox
		SET verwerkt = 1;

		COMMIT TRANSACTION;
	END
END

GO

