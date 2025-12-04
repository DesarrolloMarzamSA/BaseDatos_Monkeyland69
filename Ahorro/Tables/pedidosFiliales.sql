CREATE TABLE [Ahorro].[pedidosFiliales] (
    [cuentaEstiloAhorro]    VARCHAR (9)  NOT NULL,
    [hashMd5]               VARCHAR (50) NOT NULL,
    [orden]                 VARCHAR (8)  NOT NULL,
    [codigoBarras]          VARCHAR (13) NOT NULL,
    [sucursal]              VARCHAR (5)  NULL,
    [cuenta]                VARCHAR (5)  NULL,
    [cuentaMarzam]          VARCHAR (10) NULL,
    [tipoPedido]            VARCHAR (1)  NULL,
    [codigo]                VARCHAR (7)  NULL,
    [cantidadPedida]        INT          NULL,
    [precioFarmacia]        MONEY        NULL,
    [importeOferta]         MONEY        NULL,
    [importeProntoPago]     MONEY        NULL,
    [tipoOferta]            VARCHAR (1)  NULL,
    [porcentajeOferta]      MONEY        NULL,
    [archivoTandem]         VARCHAR (30) NULL,
    [status]                VARCHAR (1)  NULL,
    [timestamp]             DATETIME     DEFAULT (getdate()) NULL,
    [remisionado]           INT          NULL,
    [descuentoReciprocidad] MONEY        NULL,
    [descuentoAdicional1]   MONEY        NULL,
    [descuentoAdicional2]   MONEY        NULL,
    [descuentoAdicional3]   MONEY        NULL,
    [procesadoTraductor]    INT          CONSTRAINT [DF_pedidosFiliales_ProcesadoTraductor] DEFAULT ((0)) NOT NULL,
    [fechaTraductor]        DATETIME     NULL,
    [cliente]               VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([cuentaEstiloAhorro] ASC, [hashMd5] ASC, [orden] ASC, [codigoBarras] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE NONCLUSTERED INDEX [IDX_pedidosFiliales_IX]
    ON [Ahorro].[pedidosFiliales]([timestamp] ASC)
    INCLUDE([cuenta], [hashMd5], [sucursal]);


GO

