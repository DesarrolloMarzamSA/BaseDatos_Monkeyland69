CREATE TABLE [dbo].[lab_msd_factura] (
    [ClaveDist]         VARCHAR (20) NULL,
    [ClaveSucDist]      VARCHAR (20) NOT NULL,
    [FechaDoc]          VARCHAR (20) NULL,
    [ClaseFacturacion]  VARCHAR (20) NULL,
    [Numero]            VARCHAR (20) NOT NULL,
    [ClaveCliente]      VARCHAR (20) NOT NULL,
    [ClaveSubd]         VARCHAR (20) NULL,
    [Pedido]            VARCHAR (20) NULL,
    [MotivoCancelacion] VARCHAR (20) NULL,
    [CodigoMat]         VARCHAR (20) NOT NULL,
    [EAN]               VARCHAR (20) NULL,
    [CantFacturada]     INT          NULL,
    [UnidadMedida]      VARCHAR (20) NULL,
    [PrecioUnitario]    MONEY        NULL,
    [Valor]             MONEY        NULL,
    [Lote]              VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ClaveSucDist] ASC, [ClaveCliente] ASC, [Numero] ASC, [CodigoMat] ASC) WITH (FILLFACTOR = 90)
);


GO

