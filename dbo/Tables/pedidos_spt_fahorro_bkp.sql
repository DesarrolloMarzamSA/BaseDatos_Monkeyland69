CREATE TABLE [dbo].[pedidos_spt_fahorro_bkp] (
    [cuenta_estilo_ahorro] VARCHAR (9)  NOT NULL,
    [hash_md5]             VARCHAR (50) NOT NULL,
    [orden]                VARCHAR (8)  NOT NULL,
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
    [timestamp]            DATETIME     NULL,
    [remisionado]          INT          NULL,
    CONSTRAINT [PK_pedidos_spt_fahorro_bkp] PRIMARY KEY CLUSTERED ([cuenta_estilo_ahorro] ASC, [hash_md5] ASC, [orden] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

