CREATE TABLE [dbo].[pedidos_servidor_ftp_historia_tmp] (
    [sucursal]          TINYINT      NOT NULL,
    [cuenta]            VARCHAR (5)  NOT NULL,
    [orden]             INT          NOT NULL,
    [cod_barras]        VARCHAR (13) NULL,
    [cantidad_pedida]   INT          NULL,
    [cantidad_surtida]  INT          NULL,
    [motivo]            VARCHAR (5)  NULL,
    [num_pedido]        VARCHAR (9)  NULL,
    [filler1]           VARCHAR (8)  NULL,
    [codigo]            VARCHAR (7)  NULL,
    [filler2]           VARCHAR (10) NULL,
    [filler3]           VARCHAR (20) NULL,
    [precio]            MONEY        NULL,
    [porcentaje_oferta] MONEY        NULL,
    [base_oferta]       INT          NULL,
    [cant_oferta]       INT          NULL,
    [cod_credito]       VARCHAR (1)  NULL,
    [arch_cliente]      VARCHAR (20) NULL,
    [arch_tandem]       VARCHAR (8)  NULL,
    [fecha_pedido]      DATETIME     NULL,
    [fecha_tranny]      DATETIME     NULL,
    [fecha_surtido]     DATETIME     NULL,
    [fecha_resp]        DATETIME     NULL,
    [nombre]            VARCHAR (50) NULL,
    [hash_md5]          VARCHAR (50) NOT NULL,
    [longitud_registro] INT          NULL
);


GO

