CREATE TABLE [dbo].[astra_compras_ingresadas] (
    [ClaveDist]        VARCHAR (6)  NOT NULL,
    [ClaveSucDist]     VARCHAR (2)  NOT NULL,
    [FechaMovimiento]  VARCHAR (10) NOT NULL,
    [HoraMovimiento]   VARCHAR (8)  NOT NULL,
    [CodigoMat]        VARCHAR (7)  NOT NULL,
    [CodigoEAN]        VARCHAR (13) NULL,
    [ClaseMovimiento]  VARCHAR (2)  NOT NULL,
    [MotivoMovimiento] VARCHAR (2)  NOT NULL,
    [OrigenMovimiento] VARCHAR (3)  NOT NULL,
    [StatusInventario] VARCHAR (3)  NOT NULL,
    [Cantidad]         INT          NOT NULL,
    [UnidadMedida]     VARCHAR (3)  NOT NULL,
    [NumeroLote]       VARCHAR (2)  NOT NULL,
    [Texto1]           VARCHAR (2)  NOT NULL,
    [Texto2]           VARCHAR (2)  NOT NULL,
    [Texto3]           VARCHAR (2)  NOT NULL,
    PRIMARY KEY CLUSTERED ([ClaveDist] ASC, [ClaveSucDist] ASC, [FechaMovimiento] ASC, [CodigoMat] ASC, [Cantidad] ASC) WITH (FILLFACTOR = 90)
);


GO

