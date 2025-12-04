CREATE TABLE [dbo].[pedidos_spt_fahorro] (
    [cuenta_estilo_ahorro] VARCHAR (9)  NOT NULL,
    [hash_md5]             VARCHAR (50) NOT NULL,
    [orden]                VARCHAR (50) NOT NULL,
    [cod_barras]           VARCHAR (13) NOT NULL,
    [sucursal]             INT          NULL,
    [cuenta]               VARCHAR (5)  NULL,
    [tipo_pedido]          VARCHAR (1)  NULL,
    [codigo]               VARCHAR (7)  NULL,
    [cant_ped]             INT          NULL,
    [precio_far]           MONEY        NULL,
    [importe_oferta]       MONEY        NULL,
    [importe_pronto_pago]  MONEY        NULL,
    [tipo_oferta]          VARCHAR (1)  NULL,
    [porcentaje_oferta]    MONEY        NULL,
    [arch_tandem]          VARCHAR (10) NULL,
    [status]               VARCHAR (1)  NULL,
    [timestamp]            DATETIME     CONSTRAINT [DF__pedidos_s__times__09F455BC] DEFAULT (getdate()) NULL,
    [remisionado]          INT          NULL,
    [procesado_traductor]  INT          CONSTRAINT [DF_pedidos_spt_fahorro_procesado_traductor] DEFAULT ((0)) NOT NULL,
    [fecha_procesado]      DATETIME     NULL,
    [id_traductor]         VARCHAR (50) NULL,
    CONSTRAINT [PK__pedidos_spt_faho__09003183] PRIMARY KEY CLUSTERED ([cuenta_estilo_ahorro] ASC, [hash_md5] ASC, [orden] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_fecha_pedidos_spt_fahorro]
    ON [dbo].[pedidos_spt_fahorro]([timestamp] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pedidos_spt_fahorro]
    ON [dbo].[pedidos_spt_fahorro]([sucursal] ASC, [orden] ASC, [cod_barras] ASC, [cuenta] ASC, [cant_ped] ASC, [codigo] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20150310-124239]
    ON [dbo].[pedidos_spt_fahorro]([cuenta_estilo_ahorro] ASC, [hash_md5] ASC, [orden] ASC, [codigo] ASC, [timestamp] ASC) WITH (FILLFACTOR = 90);


GO

