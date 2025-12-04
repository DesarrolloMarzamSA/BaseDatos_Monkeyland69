CREATE TABLE [dbo].[fahorro_normal_facturas_entregadas] (
    [sucursal] TINYINT      NULL,
    [factura]  VARCHAR (20) NULL,
    [cliente]  VARCHAR (20) NULL,
    [orden]    CHAR (35)    NULL,
    [hash_md5] VARCHAR (50) NULL,
    [fecha]    DATETIME     NULL,
    [archivo]  VARCHAR (50) NULL
);


GO

