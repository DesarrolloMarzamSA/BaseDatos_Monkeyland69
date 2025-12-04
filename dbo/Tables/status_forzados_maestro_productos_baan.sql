CREATE TABLE [dbo].[status_forzados_maestro_productos_baan] (
    [codigo] VARCHAR (7)  NOT NULL,
    [status] VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

