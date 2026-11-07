CREATE TABLE [migraine].[inbox_json] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [datum]        DATETIME2 (0)  CONSTRAINT [DF_inbox_json_datum] DEFAULT (sysdatetime()) NOT NULL,
    [omschrijving] NVARCHAR (100) NULL,
    [registraties] NVARCHAR (MAX) NOT NULL,
    [verwerkt]     BIT            CONSTRAINT [DF_inbox_json_verwerkt] DEFAULT ((0)) NOT NULL,
    [verwerkt_op]  DATETIME2 (0)  NULL,
    CONSTRAINT [PK_inbox_json] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_inbox_json_registraties] CHECK (isjson([registraties]) = 1)
);


GO

CREATE NONCLUSTERED INDEX [IX_inbox_json_verwerkt]
    ON [migraine].[inbox_json]([verwerkt] ASC, [datum] ASC);


GO

