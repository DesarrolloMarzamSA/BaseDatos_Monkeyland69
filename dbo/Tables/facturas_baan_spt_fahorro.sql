CREATE TABLE [dbo].[facturas_baan_spt_fahorro] (
    [sucursal] TINYINT     NOT NULL,
    [factura]  VARCHAR (8) NOT NULL,
    [cliente]  VARCHAR (5) NULL,
    [tipo_doc] VARCHAR (3) NULL,
    [monto]    MONEY       NULL,
    [fecha]    DATETIME    NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [factura] ASC) WITH (FILLFACTOR = 90)
);


GO

