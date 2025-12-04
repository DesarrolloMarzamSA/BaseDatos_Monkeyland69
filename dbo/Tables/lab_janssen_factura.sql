CREATE TABLE [dbo].[lab_janssen_factura] (
    [ClaveDist]         VARCHAR (20) NULL,
    [ClaveSucDist]      VARCHAR (20) NULL,
    [FechaDoc]          VARCHAR (20) NULL,
    [ClaseFacturacion]  VARCHAR (20) NULL,
    [Numero]            VARCHAR (20) NULL,
    [ClaveCliente]      VARCHAR (20) NULL,
    [ClaveSubd]         VARCHAR (20) NULL,
    [Pedido]            VARCHAR (20) NULL,
    [MotivoCancelacion] VARCHAR (20) NULL,
    [CodigoMat]         VARCHAR (20) NULL,
    [EAN]               VARCHAR (20) NULL,
    [CantFacturada]     INT          NULL,
    [UnidadMedida]      VARCHAR (20) NULL,
    [PrecioUnitario]    MONEY        NULL,
    [Valor]             MONEY        NULL,
    [Lote]              VARCHAR (20) NULL
);


GO

CREATE NONCLUSTERED INDEX [idx_ljanssen_fe]
    ON [dbo].[lab_janssen_factura]([ClaveSucDist] ASC, [ClaveCliente] ASC, [FechaDoc] ASC, [Numero] ASC, [Pedido] ASC, [CodigoMat] ASC, [EAN] ASC, [CantFacturada] ASC) WITH (FILLFACTOR = 90);


GO

