CREATE TABLE [dbo].[pemex_oc] (
    [fecha_oc]      SMALLDATETIME NULL,
    [orden_siaf]    VARCHAR (20)  NOT NULL,
    [orden_sap]     VARCHAR (20)  NULL,
    [contrato]      VARCHAR (10)  NULL,
    [unidad_medica] VARCHAR (100) NULL,
    [elaboro]       VARCHAR (100) NULL,
    [fecha_elabora] SMALLDATETIME NULL,
    [copade]        VARCHAR (10)  NULL,
    [archivo]       VARCHAR (50)  NULL,
    [archivo_pdf]   VARCHAR (50)  NULL,
    [archivo_xml]   VARCHAR (50)  NULL,
    [sucursal]      INT           NULL,
    [cliente]       VARCHAR (5)   NULL,
    [serie_cfd]     VARCHAR (2)   NULL,
    [folio_fiscal]  VARCHAR (10)  NULL,
    [hash_md5]      VARCHAR (200) NULL,
    [registro]      DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([orden_siaf] ASC) WITH (FILLFACTOR = 90)
);


GO

