CREATE TABLE [dbo].[cfd_soriana_acuses_de_recibo13082013] (
    [fecha_recibo]      DATE         NULL,
    [fecha_factura]     DATE         NULL,
    [fecha_paquete]     DATE         NULL,
    [numTienda]         INT          NOT NULL,
    [documento_soriana] VARCHAR (50) NOT NULL,
    [folio_acuse]       INT          NULL,
    [serie_cfd]         VARCHAR (2)  NULL,
    [folio_fiscal]      VARCHAR (10) NULL,
    [importe_bruto]     MONEY        NULL,
    [timestamp]         DATETIME     NULL,
    [usr]               VARCHAR (10) NULL,
    [addenda]           BIT          NULL,
    [remision]          VARCHAR (10) NULL,
    [reporte]           INT          NULL,
    [pagina]            INT          NULL,
    [linea]             INT          NULL,
    [sucursal]          INT          NULL,
    [cliente]           VARCHAR (6)  NULL,
    [cliente_ibs]       VARCHAR (6)  NULL
);


GO

