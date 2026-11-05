CREATE TABLE [migraine_new].[registratie] (
    [datum]          NVARCHAR (10) NULL,
    [dag]            NVARCHAR (2)  NULL,
    [idagdeel]       INT           NULL,
    [dagdeel]        NVARCHAR (10) NULL,
    [isoort]         INT           NULL,
    [soort]          NVARCHAR (20) NULL,
    [isignaal]       INT           NULL,
    [signaal]        NVARCHAR (20) NULL,
    [rebound]        INT           NULL,
    [ilocatie]       INT           NULL,
    [locatie]        NVARCHAR (20) NULL,
    [imedicatie]     INT           NULL,
    [medicatie]      NVARCHAR (30) NULL,
    [medicatie_tijd] NVARCHAR (10) NULL
);


GO

