CREATE EXTERNAL DATA SOURCE [MigraineInboxBlob]
    WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = N'https://migrainefl.blob.core.windows.net/inbox',
    CREDENTIAL = [MigraineCredential]
    );


GO

