CREATE TABLE [energie].[pv_registratie] (
    [bericht_id]     NVARCHAR (100) NULL,
    [bericht_inhoud] NVARCHAR (MAX) NULL,
    [bericht_datum]  DATETIME       DEFAULT (getdate()) NULL
);


GO

