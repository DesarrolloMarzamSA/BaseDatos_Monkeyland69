CREATE TABLE [dbo].[pedidos_fbenavides] (
    [linea]            INT           NULL,
    [fecha_pedido]     SMALLDATETIME NOT NULL,
    [letra]            VARCHAR (1)   NOT NULL,
    [sucursal]         INT           NOT NULL,
    [cliente]          VARCHAR (5)   NOT NULL,
    [codigo]           VARCHAR (7)   NOT NULL,
    [descripcion]      VARCHAR (30)  NULL,
    [cod_barras]       VARCHAR (13)  NULL,
    [cantidad_surtida] INT           NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [cia]              VARCHAR (4)   NOT NULL,
    [mostrador]        VARCHAR (4)   NOT NULL,
    [cod_bena]         VARCHAR (18)  NOT NULL,
    [pedido]           VARCHAR (10)  NOT NULL,
    [arch_cliente]     VARCHAR (50)  NOT NULL,
    [archivo_hh]       VARCHAR (20)  NULL,
    [timestamp]        DATETIME      NULL,
    [rftp]             DATETIME      NULL,
    [tftp]             DATETIME      NULL,
    [hora_resp]        DATETIME      NULL,
    [hash_md5]         VARCHAR (50)  NULL,
    [estatus]          VARCHAR (1)   NULL,
    [ibs_orno]         BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([fecha_pedido] ASC, [sucursal] ASC, [cliente] ASC, [pedido] ASC, [codigo] ASC, [cantidad_pedida] ASC)
);


GO

