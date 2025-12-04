CREATE TABLE [dbo].[facturas_reingresadas_almacen] (
    [sucursal]  TINYINT     NOT NULL,
    [factura]   VARCHAR (8) NOT NULL,
    [cliente]   VARCHAR (5) NOT NULL,
    [ctepadre]  VARCHAR (3) NULL,
    [timestamp] DATETIME    DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [factura] ASC) WITH (FILLFACTOR = 90)
);


GO

