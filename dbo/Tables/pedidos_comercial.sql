CREATE TABLE [dbo].[pedidos_comercial] (
    [letra]            VARCHAR (1)   NULL,
    [sucursal]         INT           NOT NULL,
    [cuenta]           VARCHAR (5)   NOT NULL,
    [pedido]           VARCHAR (20)  NOT NULL,
    [cod_barras]       VARCHAR (13)  NOT NULL,
    [codigo]           VARCHAR (7)   NOT NULL,
    [descripcion]      VARCHAR (100) NULL,
    [mostrador]        VARCHAR (5)   NOT NULL,
    [seccion]          VARCHAR (3)   NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [cantidad_surtida] INT           NULL,
    [cap_empaque]      VARCHAR (10)  NULL,
    [uni_compra]       VARCHAR (10)  NULL,
    [arch_cliente]     VARCHAR (50)  NOT NULL,
    [hash_md5]         VARCHAR (100) NULL,
    [factura]          VARCHAR (15)  NULL,
    [encabezado]       VARCHAR (250) NULL,
    [orden]            INT           NOT NULL,
    [arch_tandem]      VARCHAR (100) NULL,
    [timestamp]        SMALLDATETIME NULL,
    [rftp]             SMALLDATETIME NULL,
    [prec_farm]        MONEY         NULL,
    [importe]          MONEY         NULL,
    [status]           INT           NULL,
    [nolinea]          INT           NULL,
    [fecha_pedido]     SMALLDATETIME NULL,
    [evento]           INT           NULL,
    [ibs_orno]         BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [pedido] ASC, [cuenta] ASC, [arch_cliente] ASC, [mostrador] ASC, [cod_barras] ASC, [codigo] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_pcc_arch_tdm]
    ON [dbo].[pedidos_comercial]([arch_tandem] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pcc_arch_tdm_cta_cod]
    ON [dbo].[pedidos_comercial]([arch_tandem] ASC, [cuenta] ASC, [codigo] ASC) WITH (FILLFACTOR = 90);


GO

