CREATE TABLE [migraine].[registratie_json] (
    [id]                INT           IDENTITY (1, 1) NOT NULL,
    [inbox_json_id]     INT           NOT NULL,
    [datum]             DATE          NOT NULL,
    [dag]               NVARCHAR (2)  NULL,
    [dagdeel]           NVARCHAR (10) NULL,
    [soort]             NVARCHAR (20) NULL,
    [signaal]           NVARCHAR (20) NULL,
    [recurrence]        NVARCHAR (5)  NULL,
    [locatie]           NVARCHAR (20) NULL,
    [medicatie_genomen] NVARCHAR (5)  NULL,
    [medicatie]         NVARCHAR (30) NULL,
    [medicatie_tijd]    NVARCHAR (10) NULL,
    CONSTRAINT [PK_registratie_json] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_registratie_json_inbox_json] FOREIGN KEY ([inbox_json_id]) REFERENCES [migraine].[inbox_json] ([id])
);


GO

CREATE NONCLUSTERED INDEX [IX_registratie_json_datum]
    ON [migraine].[registratie_json]([datum] ASC);


GO

