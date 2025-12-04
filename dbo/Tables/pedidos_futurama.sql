CREATE TABLE [dbo].[pedidos_futurama] (
    [sucursal]           TINYINT       NULL,
    [cliente]            VARCHAR (5)   NULL,
    [folio]              VARCHAR (20)  NULL,
    [cod_barras]         VARCHAR (13)  NOT NULL,
    [producto]           VARCHAR (7)   NULL,
    [prod_descrip]       VARCHAR (100) NULL,
    [numtienda]          VARCHAR (6)   NOT NULL,
    [seccion]            VARCHAR (3)   NULL,
    [cantidad]           INT           NULL,
    [surtido]            INT           NULL,
    [cap_empaque]        VARCHAR (10)  NULL,
    [uni_compra]         VARCHAR (10)  NULL,
    [archivo]            VARCHAR (10)  NULL,
    [factura]            VARCHAR (15)  NULL,
    [encabezado]         VARCHAR (250) NULL,
    [nombre_transmision] VARCHAR (100) NULL,
    [hash_md5]           VARCHAR (50)  NOT NULL,
    [timestamp]          DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([numtienda] ASC, [cod_barras] ASC, [hash_md5] ASC) WITH (FILLFACTOR = 90)
);


GO

