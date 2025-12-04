CREATE TABLE [dbo].[pedidos_minne_historia] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (5)  NOT NULL,
    [cod_barras]       VARCHAR (13) NOT NULL,
    [codigo]           VARCHAR (12) NULL,
    [pedido]           VARCHAR (10) NOT NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [arch_cliente]     VARCHAR (20) NOT NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             DATETIME     NULL,
    [tftp]             DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [orden]            INT          NOT NULL,
    [mostrador]        VARCHAR (2)  NULL,
    [descripcion]      VARCHAR (30) NULL,
    [fecha_pedido]     DATE         NOT NULL,
    PRIMARY KEY CLUSTERED ([fecha_pedido] ASC, [sucursal] ASC, [cuenta] ASC, [pedido] ASC, [cod_barras] ASC, [cantidad_pedida] ASC, [arch_cliente] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

