CREATE TABLE [dbo].[pemex_oc_detalle] (
    [fecha_oc]        SMALLDATETIME NULL,
    [orden_siaf]      VARCHAR (20)  NOT NULL,
    [curm]            VARCHAR (5)   NOT NULL,
    [descripcion]     VARCHAR (200) NULL,
    [orden]           INT           NOT NULL,
    [cantidad]        INT           NOT NULL,
    [precio_unitario] MONEY         NULL,
    [porc_iva]        MONEY         NULL,
    [sucursal]        INT           NULL,
    [cliente]         VARCHAR (5)   NULL,
    [registro]        DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([orden_siaf] ASC, [curm] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

