CREATE TABLE [dbo].[lab_janssen_pedidos] (
    [ClaveDist]    VARCHAR (20) NULL,
    [ClaveSucDist] VARCHAR (20) NOT NULL,
    [FechaDoc]     VARCHAR (20) NOT NULL,
    [Numero]       VARCHAR (20) NOT NULL,
    [ClaveCliente] VARCHAR (20) NOT NULL,
    [ClaveSubd]    VARCHAR (20) NULL,
    [MotCancel]    VARCHAR (20) NULL,
    [CodigoMat]    VARCHAR (20) NOT NULL,
    [CodigoEAN]    VARCHAR (20) NOT NULL,
    [CantSolic]    INT          NOT NULL,
    [UnidadMedida] VARCHAR (20) NULL,
    [PrecioUnit]   MONEY        NULL,
    [Valor]        MONEY        NULL,
    [CantFaltante] INT          NULL,
    [MotFaltante]  VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ClaveSucDist] ASC, [ClaveCliente] ASC, [FechaDoc] ASC, [Numero] ASC, [CodigoMat] ASC, [CodigoEAN] ASC, [CantSolic] ASC) WITH (FILLFACTOR = 90)
);


GO

