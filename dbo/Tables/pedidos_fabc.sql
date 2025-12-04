CREATE TABLE [dbo].[pedidos_fabc] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (5)  NOT NULL,
    [cod_barras]       VARCHAR (13) NOT NULL,
    [codigo]           VARCHAR (12) NULL,
    [pedido]           VARCHAR (8)  NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [arch_cliente]     VARCHAR (20) NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             VARCHAR (1)  NULL,
    [tftp]             DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [orden]            INT          NULL,
    [mostrador]        VARCHAR (2)  NULL,
    [descripcion]      VARCHAR (30) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC, [cod_barras] ASC, [cantidad_pedida] ASC)
);


GO

