CREATE TABLE [dbo].[lab_sanofi2_movimientos_inventarios] (
    [ClaveDist]        VARCHAR (20) NOT NULL,
    [ClaveSucDist]     VARCHAR (20) NOT NULL,
    [FechaMovimiento]  VARCHAR (20) NOT NULL,
    [HoraMovimiento]   VARCHAR (20) NOT NULL,
    [CodigoMat]        VARCHAR (20) NOT NULL,
    [CodigoEAN]        VARCHAR (20) NOT NULL,
    [ClaseMovimiento]  VARCHAR (20) NOT NULL,
    [MotivoMovimiento] VARCHAR (20) NOT NULL,
    [OrigenMovimiento] VARCHAR (20) NOT NULL,
    [StatusInventario] VARCHAR (20) NULL,
    [Cantidad]         INT          NOT NULL,
    [UnidadMedida]     VARCHAR (20) NULL,
    [NumeroLote]       VARCHAR (20) NULL,
    [Texto1]           VARCHAR (20) NULL,
    [Texto2]           VARCHAR (20) NULL,
    [Texto3]           VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ClaveDist] ASC, [ClaveSucDist] ASC, [FechaMovimiento] ASC, [HoraMovimiento] ASC, [CodigoMat] ASC, [CodigoEAN] ASC, [ClaseMovimiento] ASC, [MotivoMovimiento] ASC, [OrigenMovimiento] ASC, [Cantidad] ASC)
);


GO

