CREATE TABLE [Ahorro].[encabezadoFacturasAhorro] (
    [hashMd5]            VARCHAR (600) NOT NULL,
    [cuentaEstiloAhorro] VARCHAR (9)   NOT NULL,
    [orden]              VARCHAR (8)   NOT NULL,
    [sucursal]           VARCHAR (5)   NULL,
    [cuentaERP]          VARCHAR (15)  NULL,
    [nombreArchivo]      VARCHAR (50)  NULL,
    [contenido]          VARCHAR (MAX) NULL,
    [fechaInsercion]     DATETIME      NULL,
    [fechaCarga]         DATETIME      NULL,
    [fechaFactura]       DATETIME      NULL,
    [estatus]            INT           NULL,
    CONSTRAINT [PK_encabezadoFacturasAhorro_1] PRIMARY KEY CLUSTERED ([cuentaEstiloAhorro] ASC, [orden] ASC)
);


GO

