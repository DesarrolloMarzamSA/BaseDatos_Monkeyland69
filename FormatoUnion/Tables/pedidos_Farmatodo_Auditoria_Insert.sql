CREATE TABLE [FormatoUnion].[pedidos_Farmatodo_Auditoria_Insert] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (6)  NOT NULL,
    [cod_barras]       VARCHAR (13) NULL,
    [codigo]           VARCHAR (12) NOT NULL,
    [pedido]           VARCHAR (10) NOT NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [arch_cliente]     VARCHAR (20) NOT NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             VARCHAR (1)  NULL,
    [tftp]             DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [orden]            INT          NOT NULL,
    [mostrador]        VARCHAR (6)  NULL,
    [descripcion]      VARCHAR (30) NULL,
    [id]               INT          IDENTITY (1, 1) NOT NULL
);


GO

