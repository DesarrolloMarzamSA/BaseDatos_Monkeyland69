CREATE TABLE [dbo].[pedidos_funion_28012014] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (5)  NOT NULL,
    [cod_barras]       VARCHAR (13) NULL,
    [codigo]           VARCHAR (12) NOT NULL,
    [pedido]           VARCHAR (10) NOT NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [arch_cliente]     VARCHAR (20) NOT NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             VARCHAR (1)  NULL,
    [tftp]             DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [orden]            INT          NOT NULL,
    [mostrador]        VARCHAR (6)  NULL,
    [descripcion]      VARCHAR (30) NULL,
    CONSTRAINT [PK__pedidos_funion__3B01] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC, [pedido] ASC, [codigo] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

