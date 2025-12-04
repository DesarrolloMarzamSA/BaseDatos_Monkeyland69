CREATE TABLE [dbo].[pedidos_comercial_0203_1] (
    [letra]            VARCHAR (1)   NULL,
    [sucursal]         INT           NULL,
    [cuenta]           VARCHAR (5)   NULL,
    [pedido]           VARCHAR (20)  NOT NULL,
    [cod_barras]       VARCHAR (13)  NOT NULL,
    [codigo]           VARCHAR (7)   NULL,
    [descripcion]      VARCHAR (100) NULL,
    [mostrador]        VARCHAR (5)   NOT NULL,
    [seccion]          VARCHAR (3)   NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [cantidad_surtida] INT           NULL,
    [cap_empaque]      VARCHAR (10)  NULL,
    [uni_compra]       VARCHAR (10)  NULL,
    [arch_cliente]     VARCHAR (50)  NOT NULL,
    [hash_md5]         VARCHAR (100) NULL,
    [factura]          VARCHAR (15)  NULL,
    [encabezado]       VARCHAR (250) NULL,
    [orden]            INT           NULL,
    [arch_tandem]      VARCHAR (100) NULL,
    [timestamp]        DATETIME      NULL,
    [rftp]             SMALLDATETIME NULL,
    [prec_farm]        MONEY         NULL,
    [importe]          MONEY         NULL,
    [status]           INT           NULL,
    [fecha_pedido]     SMALLDATETIME NULL,
    [evento]           INT           NULL,
    [nolinea]          INT           NULL,
    [ibs_orno]         BIGINT        NULL
);


GO

