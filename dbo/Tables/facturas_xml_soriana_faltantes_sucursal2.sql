CREATE TABLE [dbo].[facturas_xml_soriana_faltantes_sucursal2] (
    [Sucursal]               NVARCHAR (255) NULL,
    [Referencia]             NVARCHAR (255) NULL,
    [Cuenta]                 NVARCHAR (255) NULL,
    [Cliente]                NVARCHAR (255) NULL,
    [IHIVN]                  FLOAT (53)     NULL,
    [fecha]                  DATETIME2 (3)  NULL,
    [importe_soriana]        FLOAT (53)     NULL,
    [Año]                    FLOAT (53)     NULL,
    [Monitor]                NVARCHAR (255) NULL,
    [Serie]                  NVARCHAR (255) NULL,
    [factura_estilo_soriana] NVARCHAR (255) NULL,
    [Tienda]                 FLOAT (53)     NULL,
    [folio_acuse]            FLOAT (53)     NULL,
    [importe_marzam]         FLOAT (53)     NULL,
    [sucursal_final]         INT            NULL,
    [rfc]                    VARCHAR (12)   NOT NULL
);


GO

