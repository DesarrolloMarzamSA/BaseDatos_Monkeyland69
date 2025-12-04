CREATE TYPE [dbo].[TableTypeDifFarmaciasAhorro] AS TABLE (
    [Dia]                 VARCHAR (20)   NULL,
    [FechaCierre]         VARCHAR (20)   NULL,
    [Proveedor]           VARCHAR (50)   NOT NULL,
    [Sucursal]            VARCHAR (25)   NOT NULL,
    [DireccionSucursal]   VARCHAR (225)  NULL,
    [Folio]               VARCHAR (25)   NULL,
    [CodigoMovimiento]    VARCHAR (25)   NULL,
    [TipoDocumento]       VARCHAR (55)   NULL,
    [Producto]            VARCHAR (25)   NULL,
    [DescripcionProducto] VARCHAR (4000) NULL,
    [Indicadores]         VARCHAR (25)   NULL,
    [Unidades]            VARCHAR (25)   NULL,
    [CostoNeto]           VARCHAR (25)   NULL,
    [IVA]                 VARCHAR (25)   NULL,
    [CostoTotal]          VARCHAR (25)   NULL,
    [Periodo]             VARCHAR (20)   NULL);


GO

