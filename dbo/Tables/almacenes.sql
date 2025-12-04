CREATE TABLE [dbo].[almacenes] (
    [almacen]     TINYINT      NOT NULL,
    [descripcion] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([almacen] ASC) WITH (FILLFACTOR = 90)
);


GO

