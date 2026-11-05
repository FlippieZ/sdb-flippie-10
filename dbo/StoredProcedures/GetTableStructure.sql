
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTableStructure] 
	@tableName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @schemaPeriod integer

	SET NOCOUNT ON;

	SET @schemaPeriod = CHARINDEX('.', @tableName, 0)

	IF @schemaPeriod > 0
		SET @tableName = SUBSTRING(@tableName, @schemaPeriod + 1, 50)

	SELECT c.name as column_name, y.name as column_type
		FROM [sys].[all_columns] c
	INNER JOIN sys.tables t ON t.object_id = c.object_id
	INNER JOIN sys.types y ON y.user_type_id = c.user_type_id
	WHERE t.name = @tableName
	ORDER BY c.column_id
END

GO

