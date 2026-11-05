CREATE TABLE [migraine].[registratie] (
    [datum]             DATE          NULL,
    [dag]               NVARCHAR (2)  NULL,
    [dagdeel]           NVARCHAR (10) NULL,
    [soort]             NVARCHAR (20) NULL,
    [signaal]           NVARCHAR (20) NULL,
    [recurrence]        NVARCHAR (5)  NULL,
    [locatie]           NVARCHAR (20) NULL,
    [medicatie_genomen] NVARCHAR (5)  NULL,
    [medicatie]         NVARCHAR (30) NULL,
    [medicatie_tijd]    NVARCHAR (10) NULL
);


GO

