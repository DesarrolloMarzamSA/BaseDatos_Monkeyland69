CREATE TABLE [dbo].[pedidos_farmatodo] (
    [folio]            VARCHAR (11) NOT NULL,
    [codigo]           VARCHAR (7)  NULL,
    [cod_barras]       VARCHAR (13) NOT NULL,
    [cant_ped]         INT          NULL,
    [cant_surt]        INT          NULL,
    [prec_unitario]    MONEY        NULL,
    [sucursal]         TINYINT      NULL,
    [numtda]           TINYINT      NOT NULL,
    [fecha]            DATETIME     NULL,
    [proveedor]        INT          NULL,
    [arch_cliente]     VARCHAR (50) NULL,
    [arch_tandem]      VARCHAR (8)  NULL,
    [nombre]           VARCHAR (50) NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [fechapedido]      DATETIME     NULL,
    [rftp]             DATETIME     NULL,
    [tftp]             DATETIME     NULL,
    [cuenta]           VARCHAR (12) NOT NULL,
    [num_pedido]       VARCHAR (12) NULL,
    CONSTRAINT [PK_pedidos_farmatodo] PRIMARY KEY CLUSTERED ([folio] ASC, [cod_barras] ASC, [numtda] ASC, [cuenta] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [num_pedido_ind]
    ON [dbo].[pedidos_farmatodo]([num_pedido] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [tftp_ind]
    ON [dbo].[pedidos_farmatodo]([tftp] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [hash_md5_ind]
    ON [dbo].[pedidos_farmatodo]([hash_md5] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [sucursal_ind]
    ON [dbo].[pedidos_farmatodo]([sucursal] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [cant_ped_ind]
    ON [dbo].[pedidos_farmatodo]([cant_ped] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [arch_cliente_ind]
    ON [dbo].[pedidos_farmatodo]([arch_cliente] ASC) WITH (FILLFACTOR = 90);


GO

