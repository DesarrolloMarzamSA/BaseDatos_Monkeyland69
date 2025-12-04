CREATE TABLE [Ahorro].[pedidosFiliales_tmp] (
    [cuentaEstiloAhorro] VARCHAR (9)  NOT NULL,
    [hashMd5]            VARCHAR (50) NOT NULL,
    [orden]              VARCHAR (8)  NOT NULL,
    [codigoBarras]       VARCHAR (13) NOT NULL,
    [sucursal]           VARCHAR (5)  NULL,
    [cuenta]             VARCHAR (5)  NULL,
    [tipoPedido]         VARCHAR (1)  NULL,
    [codigo]             VARCHAR (7)  NULL,
    [cantidadPedida]     INT          NULL,
    [precioFarmacia]     MONEY        NULL,
    [importeOferta]      MONEY        NULL,
    [importeProntoPago]  MONEY        NULL,
    [tipoOferta]         VARCHAR (1)  NULL,
    [porcentajeOferta]   MONEY        NULL,
    [archivoTandem]      VARCHAR (10) NULL,
    [status]             VARCHAR (1)  NULL,
    [timestamp]          DATETIME     NULL,
    [remisionado]        INT          NULL,
    [procesadoTraductor] INT          NOT NULL,
    [fechaTraductor]     DATETIME     NULL,
    [cliente]            VARCHAR (10) NULL
);


GO

