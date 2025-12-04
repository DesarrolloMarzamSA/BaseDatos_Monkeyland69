CREATE TABLE [dbo].[pedidos_lab_sanofi_order_line_historia] (
    [sucursal]         INT           NOT NULL,
    [letra]            CHAR (1)      NULL,
    [cliente]          VARCHAR (6)   NOT NULL,
    [recepcion]        DATETIME      NOT NULL,
    [b2b_order_number] VARCHAR (60)  NOT NULL,
    [delivery_date]    DATE          NULL,
    [pedido]           VARCHAR (50)  NULL,
    [line_key]         INT           NULL,
    [ean]              VARCHAR (14)  NOT NULL,
    [codigo]           VARCHAR (10)  NOT NULL,
    [descripcion]      VARCHAR (100) NULL,
    [cantidad_pedida]  INT           NOT NULL,
    [sa_free_quantity] INT           NULL,
    [list_price]       MONEY         NULL,
    [sell_price]       MONEY         NULL,
    [sa_discount]      MONEY         NULL,
    [l_total_amount]   MONEY         NULL,
    [timestamp]        DATETIME      DEFAULT (getdate()) NULL,
    [arch_cliente]     VARCHAR (100) NULL,
    [hash_md5]         VARCHAR (100) NULL,
    [cod_barras]       VARCHAR (13)  NULL,
    [cantidad_surtida] INT           NULL,
    [orden]            INT           NOT NULL,
    [arch_tandem]      VARCHAR (100) NULL,
    [factura]          VARCHAR (10)  NULL,
    [tftp]             DATETIME      NULL,
    [rftp]             DATETIME      NULL,
    [resultado]        INT           NULL,
    PRIMARY KEY CLUSTERED ([b2b_order_number] ASC, [sucursal] ASC, [cliente] ASC, [ean] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

