CREATE TABLE [dbo].[pedidos_solicitud_klyns] (
    [sucursal]          TINYINT      NULL,
    [cliente]           VARCHAR (5)  NOT NULL,
    [cod_barras]        VARCHAR (13) NOT NULL,
    [cant_ped]          INT          NOT NULL,
    [cant_surt]         INT          NULL,
    [codigo]            VARCHAR (7)  NULL,
    [arch_cliente]      VARCHAR (50) NOT NULL,
    [orden]             VARCHAR (50) NOT NULL,
    [hash_md5]          VARCHAR (50) NOT NULL,
    [fecha_pedido]      DATETIME     NOT NULL,
    [factura]           VARCHAR (8)  NULL,
    [eindicador]        CHAR (10)    NULL,
    [codigo_farmacia]   VARCHAR (20) NULL,
    [noenvio]           CHAR (10)    NULL,
    [folio]             CHAR (10)    NULL,
    [dindicador]        CHAR (10)    NULL,
    [refklyns]          VARCHAR (20) NULL,
    [preciofact]        MONEY        NULL,
    [preciofinal]       MONEY        NULL,
    [preciofactmarzam]  MONEY        NULL,
    [preciofinalmarzam] MONEY        NULL
);


GO

