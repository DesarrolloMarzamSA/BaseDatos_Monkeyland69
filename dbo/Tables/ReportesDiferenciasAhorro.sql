CREATE TABLE [dbo].[ReportesDiferenciasAhorro] (
    [Id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [Periodo]             INT             NOT NULL,
    [Remision]            NUMERIC (12)    NOT NULL,
    [FechaRemision]       DATETIME2 (7)   NOT NULL,
    [CuentaEstiloAhorro]  VARCHAR (15)    NULL,
    [Sucursal]            INT             NOT NULL,
    [Cuenta]              VARCHAR (11)    NOT NULL,
    [CodigoMarzam]        VARCHAR (50)    NOT NULL,
    [CodigoBarras]        NUMERIC (13)    NULL,
    [Producto]            VARCHAR (50)    NOT NULL,
    [ClasificacionFiscal] VARCHAR (50)    NOT NULL,
    [Orden]               VARCHAR (35)    NOT NULL,
    [PzasPedidasRemision] INT             NULL,
    [PzasDevueltas]       INT             NULL,
    [DevBruta]            DECIMAL (18, 4) NULL,
    [IvaDev]              DECIMAL (18, 4) NULL,
    [DescComDev]          DECIMAL (18, 4) NULL,
    [IvaDescComDev]       DECIMAL (18, 4) NULL,
    [OfertaDev]           DECIMAL (18, 4) NULL,
    [MaxRecalculo]        INT             NULL,
    [MinRecalculo]        INT             NULL,
    [DiferenciaPrecio]    DECIMAL (18, 4) NULL,
    [ImporteMarzam]       DECIMAL (18, 4) NULL,
    [IvaMarzam]           DECIMAL (18, 4) NULL,
    [TotalMarzam]         DECIMAL (18, 4) NULL,
    [BrutoDocumento]      DECIMAL (18, 4) NULL,
    [IvaDocumento]        DECIMAL (18, 4) NULL,
    [TotalDocumento]      DECIMAL (18, 4) NULL,
    [ImporteDocumento]    DECIMAL (18, 4) NULL,
    [Recalculado]         BIT             CONSTRAINT [DF_ReportesDiferenciasAhorro_Recalculado] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ReportesDiferenciasAhorro] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

CREATE CLUSTERED INDEX [IX_ReportesDiferenciasAhorro]
    ON [dbo].[ReportesDiferenciasAhorro]([Periodo] DESC);


GO

