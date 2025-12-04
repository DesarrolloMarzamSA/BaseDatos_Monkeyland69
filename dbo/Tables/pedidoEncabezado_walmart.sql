CREATE TABLE [dbo].[pedidoEncabezado_walmart] (
    [idPedido]             INT           IDENTITY (1, 1) NOT NULL,
    [encabezadoMasteredi]  VARCHAR (150) NULL,
    [numeroReferenciaMnsj] VARCHAR (50)  NOT NULL,
    [numeroOrden]          VARCHAR (50)  NOT NULL,
    [fechaDocumento]       VARCHAR (50)  NULL,
    [fechaCancelacion]     VARCHAR (50)  NULL,
    [fechaSolicitud]       VARCHAR (50)  NULL,
    [numeroDepartamento]   VARCHAR (50)  NULL,
    [numRefMutua]          VARCHAR (50)  NULL,
    [numRefAcuPromo]       VARCHAR (50)  NULL,
    [numRefProveedor]      VARCHAR (50)  NULL,
    [embarqueA]            VARCHAR (50)  NULL,
    [facturarA]            VARCHAR (50)  NULL,
    [embarqueDesde]        VARCHAR (50)  NULL,
    [mensajeDe]            VARCHAR (50)  NULL,
    [comprador]            VARCHAR (50)  NULL,
    [tiendaNueva]          VARCHAR (50)  NULL,
    [calCondPago]          VARCHAR (50)  NULL,
    [tiempoPago]           VARCHAR (50)  NULL,
    [ralacTiempoPago]      VARCHAR (50)  NULL,
    [tipoPeriodoPago]      VARCHAR (50)  NULL,
    [numPeriodoPago]       VARCHAR (50)  NULL,
    [importeTotalMsj]      MONEY         NULL,
    [lineaTotalArticulo]   INT           NULL,
    [pieMasteredi]         VARCHAR (50)  NULL,
    [estatus]              INT           NULL,
    [hashMD5]              VARCHAR (350) NOT NULL,
    [fechaPedido]          DATETIME      NULL,
    [mansajeOriginal]      VARCHAR (MAX) NULL,
    [nombreArchivo]        VARCHAR (350) NULL,
    [nombreArchivoMarzam]  VARCHAR (350) NULL,
    CONSTRAINT [PK_pedidoEncabezado_walmart] PRIMARY KEY CLUSTERED ([idPedido] ASC, [numeroReferenciaMnsj] ASC, [numeroOrden] ASC, [hashMD5] ASC) WITH (FILLFACTOR = 90)
);


GO

