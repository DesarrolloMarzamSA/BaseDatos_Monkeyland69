CREATE TABLE [dbo].[pedidos_fbenavides_CI_X] (
    [sucursal]     INT           NOT NULL,
    [cliente]      VARCHAR (5)   NOT NULL,
    [codigo]       VARCHAR (7)   NOT NULL,
    [arch_cliente] VARCHAR (50)  NOT NULL,
    [archivo_hh]   VARCHAR (20)  NULL,
    [tftp]         DATETIME      NULL,
    [hash_md5]     VARCHAR (150) NOT NULL,
    [estatus]      VARCHAR (1)   NULL,
    [pedido]       VARCHAR (10)  NOT NULL
);


GO

