CREATE TABLE [dbo].[pedidos_fmorelost_historia] (
    [fecha_pedido]             SMALLDATETIME NOT NULL,
    [pedido]                   VARCHAR (10)  NOT NULL,
    [sucursal]                 INT           NOT NULL,
    [cliente]                  VARCHAR (5)   NOT NULL,
    [cod_barras]               VARCHAR (13)  NULL,
    [codigo]                   VARCHAR (7)   NOT NULL,
    [descripcion]              VARCHAR (30)  NULL,
    [cantidad_pedida]          INT           NOT NULL,
    [cantidad_surtida]         INT           NULL,
    [piezas_con_cargo]         INT           NULL,
    [piezas_sin_cargo]         INT           NULL,
    [precio_farnacia_sin_iva]  MONEY         NULL,
    [importe_descto_oferta]    MONEY         NULL,
    [importe_descto_comercial] MONEY         NULL,
    [linea]                    INT           NOT NULL,
    [arch_cliente]             VARCHAR (100) NULL,
    [arch_tandem]              VARCHAR (20)  NULL,
    [timestamp]                DATETIME      NULL,
    [tftp]                     DATETIME      NULL,
    [rftp]                     DATETIME      NULL,
    [hash_md5]                 VARCHAR (50)  NULL,
    [hora_resp_tandem]         DATETIME      NULL,
    [motivo]                   TINYINT       NULL,
    PRIMARY KEY CLUSTERED ([fecha_pedido] ASC, [sucursal] ASC, [cliente] ASC, [pedido] ASC, [codigo] ASC, [cantidad_pedida] ASC, [linea] ASC)
);


GO

