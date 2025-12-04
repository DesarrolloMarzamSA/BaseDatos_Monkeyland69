CREATE TABLE [dbo].[pedidos_sfa] (
    [sucursal]         INT           NOT NULL,
    [cuenta]           VARCHAR (5)   NOT NULL,
    [pedido]           VARCHAR (10)  NOT NULL,
    [codigo]           VARCHAR (12)  NOT NULL,
    [cod_barras]       VARCHAR (13)  NOT NULL,
    [mostrador]        VARCHAR (8)   NOT NULL,
    [cantidad_surtida] INT           NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [descripcion]      VARCHAR (30)  NULL,
    [fecha_pedido]     SMALLDATETIME NULL,
    [arch_cliente]     VARCHAR (20)  NOT NULL,
    [hora_resp_tandem] DATETIME      NULL,
    [arch_tandem]      VARCHAR (20)  NULL,
    [rftp]             DATETIME      NULL,
    [tftp]             DATETIME      NULL,
    [orden]            INT           NULL,
    [estatus]          VARCHAR (1)   NULL,
    [hash_md5]         VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC, [pedido] ASC, [mostrador] ASC, [codigo] ASC, [cantidad_pedida] ASC) WITH (FILLFACTOR = 90)
);


GO

