CREATE TABLE [dbo].[pedidos_miniatura_historia] (
    [id_pedido]      INT           IDENTITY (1, 1) NOT NULL,
    [clienteInterno] VARCHAR (10)  NULL,
    [numeroOrden]    VARCHAR (10)  NULL,
    [codigoArticulo] VARCHAR (20)  NULL,
    [proveedor]      VARCHAR (10)  NULL,
    [cantidad]       INT           NULL,
    [cargoUnidad]    INT           NULL,
    [sinCargoUnidad] INT           NULL,
    [archivoHH]      VARCHAR (20)  NULL,
    [archivoCliente] VARCHAR (50)  NULL,
    [hashmd5]        VARCHAR (100) NULL,
    [fechaRegistro]  DATETIME      NULL,
    [codigoMarzam]   VARCHAR (35)  NULL,
    [piezasSurtidas] INT           NULL,
    [sucursal]       INT           NULL,
    [fechaRegHH]     DATETIME      NULL,
    CONSTRAINT [PK_pedidos_miniatura_historia] PRIMARY KEY CLUSTERED ([id_pedido] ASC) WITH (FILLFACTOR = 90)
);


GO

