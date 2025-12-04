CREATE TABLE [dbo].[pedidoDetalle_walmart] (
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
    CONSTRAINT [PK_pedidoDetalle_walmart] PRIMARY KEY CLUSTERED ([numeroOrden] ASC, [numeroLinea] ASC, [codigoEAN] ASC, [glnTienda] ASC, [cantidadPedida] ASC) WITH (FILLFACTOR = 90)
);


GO

