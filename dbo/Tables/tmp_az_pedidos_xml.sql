CREATE TABLE [dbo].[tmp_az_pedidos_xml] (
    [ClaveDist]    VARCHAR (20) NULL,
    [ClaveSucDist] VARCHAR (20) NULL,
    [FechaDoc]     VARCHAR (20) NULL,
    [Numero]       VARCHAR (20) NULL,
    [ClaveCliente] VARCHAR (20) NULL,
    [ClaveSubd]    VARCHAR (20) NULL,
    [MotCancel]    VARCHAR (20) NULL,
    [CodigoMat]    VARCHAR (20) NULL,
    [CodigoEAN]    VARCHAR (20) NULL,
    [CantSolic]    INT          NULL,
    [UnidadMedida] VARCHAR (20) NULL,
    [PrecioUnit]   MONEY        NULL,
    [Valor]        MONEY        NULL,
    [CantFaltante] INT          NULL,
    [MotFaltante]  VARCHAR (20) NULL
);


GO

CREATE NONCLUSTERED INDEX [idx_az_pedidos]
    ON [dbo].[tmp_az_pedidos_xml]([ClaveSucDist] ASC, [ClaveCliente] ASC, [Numero] ASC, [CodigoMat] ASC, [CantSolic] ASC);


GO

