CREATE TABLE [Ahorro].[encabezadoPedidosFilialesHistorica] (
    [hashMd5]                 VARCHAR (50)  NOT NULL,
    [nombreArchivo]           VARCHAR (50)  NULL,
    [fechaInsercion]          DATETIME      NULL,
    [estatus]                 INT           NULL,
    [numeroLineas]            INT           NULL,
    [cuentaEstiloAhorro]      VARCHAR (9)   NULL,
    [orden]                   VARCHAR (8)   NULL,
    [sucursal]                VARCHAR (5)   NULL,
    [cuenta]                  VARCHAR (5)   NULL,
    [cuentaMarzam]            VARCHAR (10)  NULL,
    [nombreHandHeld]          VARCHAR (25)  NULL,
    [fechaGeneracionHandHeld] DATETIME      NULL,
    [archivoHandHeld]         VARCHAR (MAX) NULL,
    [fechaCargaHandHeld]      DATETIME      NULL,
    [letraSucursal]           VARCHAR (5)   NULL
);


GO

