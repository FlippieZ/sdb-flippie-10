CREATE TABLE [migraine].[inbox] (
    [datum]        DATETIME       CONSTRAINT [DF_inbox_datum] DEFAULT (getdate()) NULL,
    [omschrijving] NVARCHAR (50)  NULL,
    [registraties] NVARCHAR (MAX) NULL,
    [verwerkt]     INT            CONSTRAINT [DF_inbox_verwerkt] DEFAULT ((0)) NULL
);


GO

