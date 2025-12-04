CREATE TABLE [dbo].[pedidoDetalle_walmart_historico] (
    [numeroReferenciaMnsj] VARCHAR (50)  NULL,
    [numeroOrden]          VARCHAR (50)  NOT NULL,
    [numeroLinea]          INT           NOT NULL,
    [codigoEAN]            VARCHAR (50)  NOT NULL,
    [codigoArticulo]       VARCHAR (50)  NULL,
    [codigoAsignado]       VARCHAR (50)  NULL,
    [importeArticulo]      MONEY         NULL,
    [importeBruto]         MONEY         NULL,
    [cantidadTotalPedida]  NUMERIC (18)  NULL,
    [glnTienda]            VARCHAR (50)  NOT NULL,
    [cantidadPedida]       NUMERIC (18)  NOT NULL,
    [hashMD5]              VARCHAR (350) NULL,
    CONSTRAINT [PK_pedidoDetalle_walmart_historico] PRIMARY KEY CLUSTERED ([numeroOrden] ASC, [numeroLinea] ASC, [codigoEAN] ASC, [glnTienda] ASC, [cantidadPedida] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20160819-165238]
    ON [dbo].[pedidoDetalle_walmart_historico]([numeroReferenciaMnsj] ASC, [numeroOrden] ASC, [numeroLinea] ASC, [codigoEAN] ASC, [codigoArticulo] ASC, [glnTienda] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20160819-165254]
    ON [dbo].[pedidoDetalle_walmart_historico]([numeroReferenciaMnsj] ASC, [numeroOrden] ASC, [codigoEAN] ASC, [cantidadPedida] ASC, [hashMD5] ASC) WITH (FILLFACTOR = 90);


GO

