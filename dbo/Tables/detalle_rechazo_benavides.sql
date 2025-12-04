CREATE TABLE [dbo].[detalle_rechazo_benavides] (
    [clave_proveedor]           VARCHAR (2)  NOT NULL,
    [clave_centro_distribucion] VARCHAR (2)  NOT NULL,
    [centro]                    VARCHAR (4)  NOT NULL,
    [almacen]                   VARCHAR (4)  NOT NULL,
    [num_factura]               VARCHAR (20) NOT NULL,
    [num_pedido]                VARCHAR (10) NOT NULL,
    [neto_producto]             VARCHAR (10) NOT NULL,
    [brutopro]                  VARCHAR (10) NOT NULL,
    [descuento_producto]        VARCHAR (10) NOT NULL,
    [iva_producto]              VARCHAR (10) NOT NULL,
    [iva_descuento_prodcuto]    VARCHAR (10) NULL,
    [codigo_benavides]          VARCHAR (18) NOT NULL,
    [cantidad_surtida]          VARCHAR (6)  NOT NULL,
    [tipo_error]                VARCHAR (2)  NULL,
    [fecha_proceso]             VARCHAR (8)  NOT NULL,
    [fecha_insercion]           VARCHAR (8)  NOT NULL,
    CONSTRAINT [PK_detalle_rechazo_benavides] PRIMARY KEY CLUSTERED ([centro] ASC, [num_factura] ASC, [num_pedido] ASC, [codigo_benavides] ASC, [cantidad_surtida] ASC, [fecha_proceso] ASC, [fecha_insercion] ASC)
);


GO

