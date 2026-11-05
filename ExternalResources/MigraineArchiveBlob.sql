CREATE EXTERNAL DATA SOURCE [MigraineArchiveBlob]
    WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = N'https://migrainefl.blob.core.windows.net/archive',
    CREDENTIAL = [MigraineCredential]
    );


GO

