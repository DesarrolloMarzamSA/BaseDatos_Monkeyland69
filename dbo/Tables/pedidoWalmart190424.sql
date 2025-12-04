CREATE TABLE [dbo].[pedidoWalmart190424] (
    [idPedido]             INT           IDENTITY (1, 1) NOT NULL,
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
    [nanum]                VARCHAR (15)  NULL,
    [codigo]               VARCHAR (7)   NULL,
    CONSTRAINT [PK_pedidoWalmart190424] PRIMARY KEY CLUSTERED ([idPedido] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190527-111404]
    ON [dbo].[pedidoWalmart190424]([codigoEAN] ASC, [cantidadPedida] ASC, [nanum] ASC, [codigo] ASC);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190527-111339]
    ON [dbo].[pedidoWalmart190424]([numeroOrden] ASC, [codigoEAN] ASC, [glnTienda] ASC, [nanum] ASC, [codigo] ASC);


GO

