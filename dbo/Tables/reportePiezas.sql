CREATE TABLE [dbo].[reportePiezas] (
    [almacen]         VARCHAR (5)  NULL,
    [codigoCliente]   VARCHAR (15) NULL,
    [codigoProducto]  VARCHAR (15) NULL,
    [cantidadPedida]  INT          NULL,
    [cantidadSurtida] INT          NULL,
    [fecha]           DATETIME     NULL,
    [tipoDocumento1]  VARCHAR (5)  NULL,
    [tipoDocumento2]  VARCHAR (5)  NULL,
    [cuentaPadre]     VARCHAR (10) NULL,
    [factura]         VARCHAR (15) NOT NULL,
    [lineaFactura]    INT          NOT NULL,
    CONSTRAINT [PK_reportePiezas] PRIMARY KEY CLUSTERED ([factura] ASC, [lineaFactura] ASC)
);


GO

