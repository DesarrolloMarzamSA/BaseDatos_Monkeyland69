CREATE TABLE [dbo].[pedidos_fahorro_franquicias] (
    [id_pedido]    VARCHAR (12) NOT NULL,
    [sucursal]     TINYINT      NULL,
    [cliente]      VARCHAR (5)  NOT NULL,
    [cod_barras]   VARCHAR (13) NOT NULL,
    [cant_ped]     INT          NOT NULL,
    [codigo]       VARCHAR (7)  NULL,
    [arch_cliente] VARCHAR (50) NOT NULL,
    [arch_tandem]  VARCHAR (8)  NULL,
    [orden]        BIGINT       NOT NULL,
    [hash_md5]     VARCHAR (50) NOT NULL,
    [fecha_pedido] DATETIME     NOT NULL,
    [tftp]         DATETIME     NULL,
    CONSTRAINT [PK_pedidos_fahorro_franquicias] PRIMARY KEY CLUSTERED ([id_pedido] ASC, [cliente] ASC, [cod_barras] ASC, [arch_cliente] ASC, [orden] ASC, [hash_md5] ASC, [fecha_pedido] ASC) WITH (FILLFACTOR = 90)
);


GO

