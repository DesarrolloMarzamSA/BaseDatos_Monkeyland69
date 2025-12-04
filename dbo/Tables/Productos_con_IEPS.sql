CREATE TABLE [dbo].[Productos_con_IEPS] (
    [PRODUCTO]       VARCHAR (35) NOT NULL,
    [DESCRIPCION]    VARCHAR (50) NOT NULL,
    [PAISORIGEN]     VARCHAR (4)  NULL,
    [PAISDESTINO]    VARCHAR (4)  NULL,
    [CODIGOIMPUESTO] VARCHAR (4)  NULL,
    [IVA]            VARCHAR (2)  NULL,
    [IEPS]           INT          NULL
);


GO

