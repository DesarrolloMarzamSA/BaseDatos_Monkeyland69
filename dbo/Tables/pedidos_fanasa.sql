CREATE TABLE [dbo].[pedidos_fanasa] (
    [arch_cliente]       VARCHAR (50)  NOT NULL,
    [linea_buffer]       VARCHAR (100) NULL,
    [linea]              INT           NULL,
    [cuenta]             VARCHAR (5)   NOT NULL,
    [fecha_pedido]       DATE          NOT NULL,
    [pedido]             VARCHAR (16)  NULL,
    [codigo]             VARCHAR (7)   NULL,
    [codigo_barras]      VARCHAR (13)  NOT NULL,
    [descripcion]        VARCHAR (50)  NULL,
    [precio_farm]        MONEY         NULL,
    [descto_oferta]      MONEY         NULL,
    [descto_financiero]  MONEY         NULL,
    [descto_especial]    MONEY         NULL,
    [cantidad_pedida]    INT           NOT NULL,
    [cantidad_sin_cargo] INT           NULL,
    [cantidad_surtida]   INT           NULL,
    [letra]              CHAR (1)      NULL,
    [sucursal]           INT           NULL,
    [cliente]            VARCHAR (5)   NULL,
    [cliente_ibs]        VARCHAR (7)   NULL,
    [archivo_hh]         VARCHAR (20)  NULL,
    [hash_md5]           VARCHAR (100) NULL,
    [tftp]               DATETIME      NULL,
    [rftp]               DATETIME      NULL,
    [timestamp]          DATETIME      NULL,
    [respuesta]          INT           NULL,
    [orno]               VARCHAR (8)   NULL,
    PRIMARY KEY CLUSTERED ([arch_cliente] ASC, [fecha_pedido] ASC, [cuenta] ASC, [codigo_barras] ASC, [cantidad_pedida] ASC) WITH (FILLFACTOR = 90)
);


GO

