CREATE TABLE [dbo].[isc_usr] (
    [idusr]      INT          NOT NULL,
    [usuario]    CHAR (8)     NULL,
    [contrasena] VARCHAR (8)  NULL,
    [nombres]    VARCHAR (30) NULL,
    [nivel]      INT          NULL,
    [selex]      INT          NULL,
    PRIMARY KEY CLUSTERED ([idusr] ASC) WITH (FILLFACTOR = 90)
);


GO

