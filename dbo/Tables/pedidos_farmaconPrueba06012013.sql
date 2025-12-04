CREATE TABLE [dbo].[pedidos_farmaconPrueba06012013] (
    [sucursal]               TINYINT      NULL,
    [cuenta]                 VARCHAR (7)  NOT NULL,
    [cantidad_pedida]        INT          NOT NULL,
    [cantidad_surtida]       INT          NULL,
    [cantidad_factura]       INT          NULL,
    [codigo]                 VARCHAR (7)  NULL,
    [rftp]                   DATETIME     NULL,
    [motivonosurtido_preibs] VARCHAR (50) NULL,
    [estatus]                INT          NULL,
    [arch_tandem]            VARCHAR (8)  NOT NULL
);


GO

