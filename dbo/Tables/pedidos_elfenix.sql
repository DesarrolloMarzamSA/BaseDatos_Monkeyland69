CREATE TABLE [dbo].[pedidos_elfenix] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (5)  NOT NULL,
    [cod_barras]       VARCHAR (13) NOT NULL,
    [codigo]           VARCHAR (12) NULL,
    [pedido]           VARCHAR (10) NOT NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [arch_cliente]     VARCHAR (20) NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             DATETIME     NULL,
    [tftp]             DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [orden]            INT          NOT NULL,
    [mostrador]        INT          NOT NULL,
    [descripcion]      VARCHAR (50) NULL,
    [prec_farm]        MONEY        NULL,
    [importe]          MONEY        NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC, [mostrador] ASC, [pedido] ASC, [cod_barras] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

