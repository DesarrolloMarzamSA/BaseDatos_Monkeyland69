CREATE TABLE [dbo].[pedidos_fardemex] (
    [arch_cliente]     VARCHAR (50)  NULL,
    [fecha_pedido]     DATETIME      NOT NULL,
    [pedido]           VARCHAR (10)  NOT NULL,
    [mostrador]        VARCHAR (10)  NULL,
    [cod_barras]       VARCHAR (13)  NULL,
    [codigo]           VARCHAR (7)   NOT NULL,
    [sucursal]         INT           NOT NULL,
    [letra]            CHAR (1)      NULL,
    [cliente]          VARCHAR (5)   NOT NULL,
    [cliente_ibs]      VARCHAR (6)   NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [cantidad_surtida] INT           NULL,
    [hash_md5]         VARCHAR (100) NULL,
    [linea]            INT           NULL,
    [archivo_hh]       VARCHAR (10)  NULL,
    [tftp]             DATETIME      NULL,
    [rftp]             DATETIME      NULL,
    [prec_farm]        MONEY         NULL,
    [importe]          MONEY         NULL,
    [resultado]        INT           NULL,
    [orno]             INT           NULL,
    PRIMARY KEY CLUSTERED ([fecha_pedido] ASC, [pedido] ASC, [sucursal] ASC, [cliente] ASC, [codigo] ASC, [cantidad_pedida] ASC) WITH (FILLFACTOR = 90)
);


GO

