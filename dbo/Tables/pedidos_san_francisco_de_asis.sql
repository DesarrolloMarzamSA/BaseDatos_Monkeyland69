CREATE TABLE [dbo].[pedidos_san_francisco_de_asis] (
    [sucursal]         INT          NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (5)  NOT NULL,
    [codigo]           VARCHAR (7)  NOT NULL,
    [cod_barras]       VARCHAR (13) NULL,
    [pedido]           VARCHAR (10) NOT NULL,
    [mostrador]        VARCHAR (50) NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [estatus]          VARCHAR (1)  NULL,
    [descripcion]      VARCHAR (50) NULL,
    [fecha_pedido]     VARCHAR (12) NULL,
    [arch_cliente]     VARCHAR (20) NOT NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             VARCHAR (1)  NULL,
    [tftp]             DATETIME     NULL,
    [orden]            INT          NOT NULL,
    [hash_md5]         VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([cuenta] ASC, [codigo] ASC, [pedido] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

