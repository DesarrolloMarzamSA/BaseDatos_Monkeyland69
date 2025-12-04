CREATE TABLE [dbo].[sanofi_pedidos] (
    [cufa]             VARCHAR (10) NOT NULL,
    [sucursal]         TINYINT      NULL,
    [cuenta]           VARCHAR (5)  NULL,
    [cod_barras]       VARCHAR (13) NOT NULL,
    [cantidad_pedida]  INT          NULL,
    [cantidad_surtida] INT          NULL,
    [num_pedido]       VARCHAR (9)  NULL,
    [codigo]           VARCHAR (7)  NULL,
    [arch_cliente]     VARCHAR (20) NULL,
    [arch_tandem]      VARCHAR (8)  NULL,
    [tftp]             DATETIME     NULL,
    [rftp]             DATETIME     NULL,
    [nombre]           VARCHAR (50) NULL,
    [orden]            INT          NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NOT NULL,
    [timestamp]        DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([cufa] ASC, [cod_barras] ASC, [hash_md5] ASC)
);


GO

