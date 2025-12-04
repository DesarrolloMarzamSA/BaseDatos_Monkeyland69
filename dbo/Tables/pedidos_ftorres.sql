CREATE TABLE [dbo].[pedidos_ftorres] (
    [sucursal]         INT           NOT NULL,
    [cliente]          VARCHAR (5)   NOT NULL,
    [codigo]           VARCHAR (7)   NULL,
    [cod_barras]       VARCHAR (13)  NOT NULL,
    [descripcion]      VARCHAR (100) NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [cantidad_surtida] INT           NULL,
    [costo_unitario]   MONEY         NULL,
    [costo_total]      MONEY         NULL,
    [pedido]           VARCHAR (10)  NULL,
    [arch_cliente]     VARCHAR (20)  NULL,
    [arch_tandem]      VARCHAR (20)  NULL,
    [rftp]             DATETIME      NULL,
    [tftp]             DATETIME      NULL,
    [hora_resp_tandem] DATETIME      NULL,
    [cod_torres]       VARCHAR (10)  NULL,
    [hash_md5]         VARCHAR (50)  NULL,
    [orden]            INT           NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [cod_barras] ASC, [cantidad_pedida] ASC) WITH (FILLFACTOR = 90)
);


GO

