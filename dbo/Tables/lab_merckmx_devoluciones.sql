CREATE TABLE [dbo].[lab_merckmx_devoluciones] (
    [ClaveDist]         VARCHAR (20) NULL,
    [ClaveSucDist]      VARCHAR (20) NOT NULL,
    [FechaDoc]          VARCHAR (20) NOT NULL,
    [ClaseFacturacion]  VARCHAR (20) NULL,
    [Numero]            VARCHAR (20) NOT NULL,
    [ClaveCliente]      VARCHAR (20) NOT NULL,
    [ClaveSubd]         VARCHAR (20) NULL,
    [Ref]               VARCHAR (20) NOT NULL,
    [MotivoCancelacion] VARCHAR (20) NULL,
    [CodigoMat]         VARCHAR (20) NOT NULL,
    [EAN]               VARCHAR (20) NOT NULL,
    [CantFacturada]     INT          NOT NULL,
    [UnidadMedida]      VARCHAR (20) NULL,
    [PrecioUnitario]    MONEY        NULL,
    [Valor]             MONEY        NULL,
    [Lote]              VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ClaveSucDist] ASC, [ClaveCliente] ASC, [FechaDoc] ASC, [Numero] ASC, [Ref] ASC, [CodigoMat] ASC, [EAN] ASC, [CantFacturada] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_lmerckmx_fe]
    ON [dbo].[lab_merckmx_devoluciones]([ClaveSucDist] ASC, [ClaveCliente] ASC, [FechaDoc] ASC, [Numero] ASC, [Ref] ASC, [CodigoMat] ASC, [EAN] ASC, [CantFacturada] ASC) WITH (FILLFACTOR = 90);


GO

