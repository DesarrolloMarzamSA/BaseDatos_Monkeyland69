CREATE TABLE [dbo].[series_facturacion] (
    [sucursal]  TINYINT     NOT NULL,
    [serie]     VARCHAR (1) NULL,
    [serie_cfd] VARCHAR (5) NULL,
    [serie_sql] CHAR (2)    NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

