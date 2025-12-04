CREATE TABLE [dbo].[pedidos_farmapronto_facturacion] (
    [sucursal]     TINYINT      NOT NULL,
    [cliente]      VARCHAR (5)  NOT NULL,
    [arch_tandem]  VARCHAR (8)  NULL,
    [arch_cliente] VARCHAR (50) NOT NULL,
    [factura]      VARCHAR (8)  NOT NULL,
    [orden]        VARCHAR (50) NOT NULL,
    [fecha]        DATETIME     NULL,
    CONSTRAINT [PK_pedidos_farmapronto_facturacion] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [arch_cliente] ASC, [factura] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

