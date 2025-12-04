CREATE TABLE [dbo].[pedidos_fyza_20] (
    [arch_cliente]        VARCHAR (50)  NOT NULL,
    [linea_buffer]        VARCHAR (100) NULL,
    [linea]               INT           NULL,
    [fecha_pedido]        DATE          NOT NULL,
    [letra]               CHAR (1)      NULL,
    [sucursal]            INT           NULL,
    [cliente]             VARCHAR (5)   NULL,
    [cliente_ibs]         VARCHAR (7)   NULL,
    [codigo]              VARCHAR (7)   NULL,
    [descripcion]         VARCHAR (50)  NULL,
    [pedido]              VARCHAR (16)  NULL,
    [archivo_hh]          VARCHAR (20)  NULL,
    [cantidad_pedida]     INT           NULL,
    [cantidad_surtida]    INT           NULL,
    [hash_md5]            VARCHAR (100) NULL,
    [tftp]                DATETIME      NULL,
    [rftp]                DATETIME      NULL,
    [timestamp]           DATETIME      NULL,
    [compania]            VARCHAR (3)   NULL,
    [proveedor]           VARCHAR (6)   NULL,
    [orden_pharmacy]      VARCHAR (10)  NOT NULL,
    [bodega]              VARCHAR (5)   NULL,
    [tienda]              VARCHAR (7)   NOT NULL,
    [upc]                 VARCHAR (13)  NOT NULL,
    [cantidad_solicitada] INT           NOT NULL,
    [precio]              MONEY         NULL,
    [departamento]        MONEY         NULL,
    [unid_med]            VARCHAR (4)   NULL,
    [fecha_emision]       VARCHAR (8)   NULL,
    PRIMARY KEY CLUSTERED ([arch_cliente] ASC, [fecha_pedido] ASC, [orden_pharmacy] ASC, [tienda] ASC, [upc] ASC, [cantidad_solicitada] ASC) WITH (FILLFACTOR = 90)
);


GO

