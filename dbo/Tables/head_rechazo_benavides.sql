CREATE TABLE [dbo].[head_rechazo_benavides] (
    [clave_proveedor]           VARCHAR (2)  NOT NULL,
    [clave_centro_distribucion] VARCHAR (2)  NOT NULL,
    [num_factura]               VARCHAR (20) NOT NULL,
    [num_registros]             VARCHAR (4)  NOT NULL,
    [fecha_factura]             VARCHAR (8)  NOT NULL,
    [num_pedido]                VARCHAR (10) NOT NULL,
    [centro]                    VARCHAR (4)  NOT NULL,
    [almacen]                   VARCHAR (4)  NOT NULL,
    [neto]                      VARCHAR (10) NOT NULL,
    [iva]                       VARCHAR (10) NOT NULL,
    [bruto]                     VARCHAR (10) NULL,
    [descuento]                 VARCHAR (10) NULL,
    [iva_descuento]             VARCHAR (10) NULL,
    [clave_factura]             VARCHAR (2)  NULL,
    [tipo_error]                VARCHAR (2)  NULL,
    [fecha_proceso]             VARCHAR (8)  NOT NULL,
    CONSTRAINT [PK_head_rechazo_benavides] PRIMARY KEY CLUSTERED ([num_factura] ASC, [num_registros] ASC, [centro] ASC, [fecha_proceso] ASC)
);


GO

