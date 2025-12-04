CREATE TABLE [dbo].[pedidos_spt_fahorro_20230111] (
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
    [procesado_traductor]  INT          NOT NULL,
    [fecha_procesado]      DATETIME     NULL,
    [id_traductor]         VARCHAR (50) NULL
);


GO

