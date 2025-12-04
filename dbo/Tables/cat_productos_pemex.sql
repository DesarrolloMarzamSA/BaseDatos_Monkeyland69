CREATE TABLE [dbo].[cat_productos_pemex] (
    [codigo]      VARCHAR (7)   NOT NULL,
    [curm]        VARCHAR (7)   NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [status]      VARCHAR (2)   NULL,
    [timestamp]   DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

