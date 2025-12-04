CREATE TABLE [dbo].[pedidos_fahorro_conciliacion] (
    [cuenta_estilo_ahorro] VARCHAR (9)  NOT NULL,
    [hash_md5]             VARCHAR (50) NOT NULL,
    [orden]                INT          NOT NULL,
    [cod_barras]           VARCHAR (13) NOT NULL,
    [sucursal]             INT          NULL,
    [cuenta]               VARCHAR (5)  NOT NULL,
    [tipo_pedido]          VARCHAR (1)  NULL,
    [codigo]               VARCHAR (7)  NOT NULL,
    [cant_ped]             INT          NOT NULL,
    [precio_far]           MONEY        NOT NULL,
    [importe_oferta]       MONEY        NULL,
    [importe_pronto_pago]  MONEY        NULL,
    [tipo_oferta]          VARCHAR (1)  NULL,
    [porcentaje_oferta]    MONEY        NULL,
    [arch_tandem]          VARCHAR (10) NULL,
    [status]               VARCHAR (1)  NULL,
    [timestamp]            DATETIME     NULL,
    [remisionado]          INT          NULL,
    [periodo]              INT          NOT NULL,
    CONSTRAINT [PK_pedidos_fahorro_conciliacion] PRIMARY KEY CLUSTERED ([cuenta_estilo_ahorro] ASC, [orden] ASC, [cuenta] ASC, [codigo] ASC, [cant_ped] ASC, [precio_far] ASC, [periodo] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180307-123335]
    ON [dbo].[pedidos_fahorro_conciliacion]([orden] ASC, [sucursal] ASC, [cuenta] ASC, [precio_far] ASC, [importe_oferta] ASC, [importe_pronto_pago] ASC, [porcentaje_oferta] ASC, [periodo] ASC) WITH (FILLFACTOR = 90);


GO

