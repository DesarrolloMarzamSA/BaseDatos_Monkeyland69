CREATE TABLE [dbo].[pedidos_sanofi] (
    [md5]                VARCHAR (50) NOT NULL,
    [b2b_order_number]   VARCHAR (60) NOT NULL,
    [LineKey]            VARCHAR (30) NOT NULL,
    [Sku]                VARCHAR (32) NULL,
    [Quantity]           INT          NULL,
    [SafreeQuantity]     INT          NULL,
    [ListPrice]          FLOAT (53)   NULL,
    [SellPrice]          FLOAT (53)   NULL,
    [SaDiscount]         FLOAT (53)   NULL,
    [DeliveryDate]       VARCHAR (30) NULL,
    [TotalAmount]        FLOAT (53)   NULL,
    [cantidad_entregada] INT          CONSTRAINT [DF_pedidos_sanofi_cantidad_entregada] DEFAULT ((0)) NOT NULL,
    [precio_facturado]   FLOAT (53)   CONSTRAINT [DF_pedidos_sanofi_precio_facturado] DEFAULT ((0.0)) NOT NULL,
    [order_line_status]  AS           (case when [cantidad_entregada]>(0) then 'In Process' when [cantidad_entregada]=(0) then 'Rejected'  end),
    CONSTRAINT [PK_pedidos_sanofi] PRIMARY KEY CLUSTERED ([md5] ASC, [b2b_order_number] ASC, [LineKey] ASC) WITH (FILLFACTOR = 90)
);


GO

