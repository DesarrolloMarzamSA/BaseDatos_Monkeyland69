CREATE TABLE [dbo].[cat_farmatodo_facturacion] (
    [farmacia] VARCHAR (70) NULL,
    [sucursal] TINYINT      NOT NULL,
    [tienda]   TINYINT      NOT NULL,
    [cliente]  VARCHAR (5)  NOT NULL,
    CONSTRAINT [PK_cat_farmatodo_facturacion_1] PRIMARY KEY CLUSTERED ([tienda] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

