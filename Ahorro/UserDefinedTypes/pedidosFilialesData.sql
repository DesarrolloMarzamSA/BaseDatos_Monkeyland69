CREATE TYPE [Ahorro].[pedidosFilialesData] AS TABLE (
    [cuentaEstiloAhorro] VARCHAR (9)   NOT NULL,
    [hashMd5]            VARCHAR (50)  NOT NULL,
    [ordenCliente]       VARCHAR (8)   NOT NULL,
    [codigoBarras]       VARCHAR (13)  NOT NULL,
    [tipoPedido]         VARCHAR (1)   NULL,
    [cantidadPedida]     INT           NULL,
    [precioFarmacia]     MONEY         NULL,
    [importeOferta]      MONEY         NULL,
    [importeProntoPago]  MONEY         NULL,
    [tipoOferta]         VARCHAR (1)   NULL,
    [porcentajeOferta]   MONEY         NULL,
    [archivoCliente]     VARCHAR (255) NULL);


GO

