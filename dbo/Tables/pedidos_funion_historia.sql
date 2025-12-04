CREATE TABLE [dbo].[pedidos_funion_historia] (
    [fecha]            SMALLDATETIME NOT NULL,
    [sucursal]         INT           NOT NULL,
    [cuenta]           VARCHAR (5)   NOT NULL,
    [cod_barras]       VARCHAR (13)  NULL,
    [codigo]           VARCHAR (12)  NOT NULL,
    [pedido]           VARCHAR (10)  NOT NULL,
    [cantidad_surtida] INT           NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [arch_cliente]     VARCHAR (20)  NOT NULL,
    [hora_resp_tandem] DATETIME      NULL,
    [arch_tandem]      VARCHAR (20)  NOT NULL,
    [orden]            INT           NOT NULL,
    [rftp]             DATETIME      NULL,
    [tftp]             DATETIME      NULL,
    [descripcion]      VARCHAR (30)  NULL,
    [mostrador]        VARCHAR (6)   NULL,
    CONSTRAINT [PK__pedidos___48A5177F42ADB02B] PRIMARY KEY CLUSTERED ([fecha] ASC, [sucursal] ASC, [cuenta] ASC, [pedido] ASC, [codigo] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

