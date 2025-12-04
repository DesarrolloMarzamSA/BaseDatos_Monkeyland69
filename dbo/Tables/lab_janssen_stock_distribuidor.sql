CREATE TABLE [dbo].[lab_janssen_stock_distribuidor] (
    [ClaveDist]        VARCHAR (20) NOT NULL,
    [ClaveSucDist]     VARCHAR (20) NOT NULL,
    [FechaImg]         VARCHAR (20) NOT NULL,
    [HoraImg]          VARCHAR (20) NOT NULL,
    [CodigoMat]        VARCHAR (20) NOT NULL,
    [CodigoEAN]        VARCHAR (20) NOT NULL,
    [StatusInventario] VARCHAR (20) NULL,
    [MotivoBloqueo]    VARCHAR (20) NULL,
    [Cantidad]         INT          NOT NULL,
    [UnidadMedida]     VARCHAR (20) NULL,
    [NumeroLote]       VARCHAR (20) NULL,
    [Texto1]           VARCHAR (20) NULL,
    [Texto2]           VARCHAR (20) NULL,
    [Texto3]           VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ClaveDist] ASC, [ClaveSucDist] ASC, [FechaImg] ASC, [HoraImg] ASC, [CodigoMat] ASC, [CodigoEAN] ASC, [Cantidad] ASC) WITH (FILLFACTOR = 90)
);


GO

