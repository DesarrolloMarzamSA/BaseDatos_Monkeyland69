CREATE TABLE [Ahorro].[TmpFacturasFaltantes] (
    [cuentaEstiloAhorro]    VARCHAR (9)     NULL,
    [hashMD5]               VARCHAR (50)    NULL,
    [orden]                 VARCHAR (35)    NULL,
    [codigoBarras]          VARCHAR (35)    NULL,
    [sucursal]              TINYINT         NULL,
    [cuenta]                VARCHAR (5)     NULL,
    [cuentaMarzam]          VARCHAR (11)    NULL,
    [tipoPedido]            VARCHAR (1)     NOT NULL,
    [codigo]                VARCHAR (35)    NULL,
    [cantidadPedida]        INT             NULL,
    [precioFarmacia]        NUMERIC (17, 4) NOT NULL,
    [importeOferta]         NUMERIC (1, 1)  NOT NULL,
    [importeProntoPago]     NUMERIC (1, 1)  NOT NULL,
    [tipoOferta]            VARCHAR (1)     NOT NULL,
    [porcentajeOferta]      NUMERIC (1, 1)  NOT NULL,
    [archivoTandem]         VARCHAR (1)     NOT NULL,
    [status]                VARCHAR (1)     NOT NULL,
    [timestamp]             DATETIME        NULL,
    [remisionado]           INT             NULL,
    [descuentoReciprocidad] INT             NULL,
    [descuentoAdicional1]   INT             NULL,
    [descuentoAdicional2]   INT             NULL,
    [descuentoAdicional3]   INT             NULL,
    [procesadoTraductor]    INT             NOT NULL,
    [fehaTraductor]         INT             NULL,
    [cliente]               INT             NULL
);


GO

