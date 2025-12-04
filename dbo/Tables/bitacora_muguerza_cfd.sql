CREATE TABLE [dbo].[bitacora_muguerza_cfd] (
    [fecha]        DATE           NULL,
    [registro]     DATETIME       NOT NULL,
    [serie_cfd]    VARCHAR (2)    NOT NULL,
    [folio_fiscal] VARCHAR (8)    NOT NULL,
    [orden]        CHAR (9)       NULL,
    [sucursal]     INT            NULL,
    [cliente]      VARCHAR (5)    NULL,
    [cliente_ibs]  VARCHAR (6)    NULL,
    [remision]     VARCHAR (10)   NULL,
    [importe]      MONEY          NULL,
    [confirmada]   BIT            NULL,
    [intento]      INT            NULL,
    [msg_error]    VARCHAR (255)  NULL,
    [archivo_xml]  VARCHAR (100)  NULL,
    [archivo_pdf]  VARCHAR (100)  NULL,
    [cod_aperak]   INT            NULL,
    [xml_original] VARCHAR (100)  NULL,
    [xml_data]     VARCHAR (2000) NULL,
    [um]           INT            NULL,
    CONSTRAINT [PK__bitacora__1C350CF74BED01A2] PRIMARY KEY CLUSTERED ([serie_cfd] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_bit_mug_suc_folio]
    ON [dbo].[bitacora_muguerza_cfd]([sucursal] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90);


GO

