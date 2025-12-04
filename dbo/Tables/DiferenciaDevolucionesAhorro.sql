CREATE TABLE [dbo].[DiferenciaDevolucionesAhorro] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [Dia]                 VARCHAR (20)   NULL,
    [FechaCierre]         VARCHAR (20)   NULL,
    [Proveedor]           VARCHAR (50)   NOT NULL,
    [Sucursal]            VARCHAR (25)   NOT NULL,
    [DireccionSucursal]   VARCHAR (225)  NULL,
    [Folio]               NUMERIC (18)   NULL,
    [CodigoMovimiento]    VARCHAR (25)   NULL,
    [TipoDocumento]       VARCHAR (55)   NULL,
    [Producto]            NUMERIC (18)   NULL,
    [DescripcionProducto] VARCHAR (4000) NULL,
    [Indicadores]         VARCHAR (25)   NULL,
    [Unidades]            NUMERIC (18)   NULL,
    [CostoNeto]           VARCHAR (25)   NULL,
    [IVA]                 VARCHAR (25)   NULL,
    [CostoTotal]          VARCHAR (25)   NULL,
    [Periodo]             VARCHAR (20)   NOT NULL,
    [Manual]              BIT            CONSTRAINT [DF_DiferenciaDevolucionesAhorro_Manual] DEFAULT ((0)) NULL,
    [FechaRegistro]       DATETIME       CONSTRAINT [DF_DiferenciaDevolucionesAhorro_FechaRegistro] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__Diferenc__3214EC0713D5F30D] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171116-165112]
    ON [dbo].[DiferenciaDevolucionesAhorro]([Folio] ASC, [Producto] ASC, [Unidades] ASC, [Periodo] ASC) WITH (FILLFACTOR = 90);


GO

