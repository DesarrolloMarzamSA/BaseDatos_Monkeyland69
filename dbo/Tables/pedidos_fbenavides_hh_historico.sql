CREATE TABLE [dbo].[pedidos_fbenavides_hh_historico] (
    [sucursal]     INT           NOT NULL,
    [cliente]      VARCHAR (5)   NOT NULL,
    [codigo]       VARCHAR (7)   NOT NULL,
    [arch_cliente] VARCHAR (50)  NOT NULL,
    [archivo_hh]   VARCHAR (20)  NULL,
    [tftp]         DATETIME      NULL,
    [hash_md5]     VARCHAR (150) NOT NULL,
    [estatus]      VARCHAR (1)   NULL,
    [pedido]       VARCHAR (10)  NOT NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [pedido] ASC, [codigo] ASC, [hash_md5] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20170616-104517]
    ON [dbo].[pedidos_fbenavides_hh_historico]([cliente] ASC, [tftp] ASC, [hash_md5] ASC) WITH (FILLFACTOR = 90);


GO

