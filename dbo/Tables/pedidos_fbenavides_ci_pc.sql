CREATE TABLE [dbo].[pedidos_fbenavides_ci_pc] (
    [linea]              INT           NOT NULL,
    [fecha_pedido]       SMALLDATETIME NOT NULL,
    [letra]              VARCHAR (1)   NOT NULL,
    [sucursal]           INT           NOT NULL,
    [cliente]            VARCHAR (5)   NOT NULL,
    [codigo]             VARCHAR (7)   NOT NULL,
    [descripcion]        VARCHAR (30)  NULL,
    [cod_barras]         VARCHAR (13)  NULL,
    [cantidad_surtida]   INT           NULL,
    [cantidad_pedida]    INT           NOT NULL,
    [cia]                VARCHAR (4)   NOT NULL,
    [mostrador]          VARCHAR (4)   NOT NULL,
    [cod_bena]           VARCHAR (18)  NOT NULL,
    [pedido]             VARCHAR (10)  NOT NULL,
    [arch_cliente]       VARCHAR (50)  NOT NULL,
    [archivo_hh]         VARCHAR (20)  NULL,
    [timestamp]          DATETIME      NULL,
    [rftp]               DATETIME      NULL,
    [tftp]               DATETIME      NULL,
    [hora_resp]          DATETIME      NULL,
    [hash_md5]           VARCHAR (150) NOT NULL,
    [estatus]            VARCHAR (1)   NULL,
    [ibs_orno]           BIGINT        NULL,
    [precio_farmacia]    VARCHAR (20)  NULL,
    [porcentaje_oferta]  VARCHAR (10)  NULL,
    [porcentaje_descto]  VARCHAR (10)  NULL,
    [porcentaje_descto1] VARCHAR (10)  NULL,
    [porcentaje_descto2] VARCHAR (10)  NULL,
    [porcentaje_descto3] VARCHAR (10)  NULL,
    [porcentaje_descto4] VARCHAR (10)  NULL,
    [porcentaje_iva]     VARCHAR (10)  NULL,
    [precio_costo]       VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([linea] ASC, [fecha_pedido] ASC, [sucursal] ASC, [cliente] ASC, [pedido] ASC, [codigo] ASC, [cantidad_pedida] ASC, [hash_md5] ASC) WITH (FILLFACTOR = 90)
);


GO

