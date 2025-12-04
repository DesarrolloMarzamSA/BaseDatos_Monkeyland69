CREATE TABLE [dbo].[catalogo_productos_sanborns] (
    [sku]         VARCHAR (10)  NOT NULL,
    [depto]       VARCHAR (10)  NULL,
    [subdepto]    VARCHAR (10)  NULL,
    [clase]       VARCHAR (10)  NULL,
    [cod_barras]  VARCHAR (13)  NOT NULL,
    [art_prov]    VARCHAR (10)  NULL,
    [descripcion] VARCHAR (50)  NULL,
    [hostname]    VARCHAR (100) NULL,
    [timestamp]   DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([sku] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

