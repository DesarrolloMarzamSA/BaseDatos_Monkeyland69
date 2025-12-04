CREATE TABLE [dbo].[pedidos_benavides_historia] (
    [sucursal]         INT           NOT NULL,
    [cuenta]           VARCHAR (5)   NOT NULL,
    [pedido]           VARCHAR (10)  NOT NULL,
    [cod_bena]         VARCHAR (18)  NOT NULL,
    [codigo]           VARCHAR (12)  NOT NULL,
    [cod_barras]       VARCHAR (13)  NOT NULL,
    [cia]              VARCHAR (8)   NOT NULL,
    [mostrador]        VARCHAR (8)   NOT NULL,
    [estatus]          VARCHAR (1)   NULL,
    [cantidad_surtida] INT           NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [descripcion]      VARCHAR (30)  NULL,
    [fecha_pedido]     VARCHAR (12)  NULL,
    [arch_cliente]     VARCHAR (100) NOT NULL,
    [hora_resp_tandem] DATETIME      NULL,
    [arch_tandem]      VARCHAR (20)  NULL,
    [rftp]             VARCHAR (1)   NULL,
    [tftp]             DATETIME      NULL,
    [orden]            INT           NULL,
    [letra]            VARCHAR (1)   NULL,
    [hash_md5]         VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC, [pedido] ASC, [cia] ASC, [mostrador] ASC, [cod_bena] ASC, [cantidad_pedida] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_ped_benav_historia]
    ON [dbo].[pedidos_benavides_historia]([fecha_pedido] ASC) WITH (FILLFACTOR = 90);


GO

