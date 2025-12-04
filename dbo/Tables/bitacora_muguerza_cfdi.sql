CREATE TABLE [dbo].[bitacora_muguerza_cfdi] (
    [registro]     DATETIME      NOT NULL,
    [serie_cfd]    VARCHAR (2)   NOT NULL,
    [folio_fiscal] VARCHAR (8)   NOT NULL,
    [orden]        CHAR (9)      NULL,
    [sucursal]     INT           NULL,
    [cliente_ibs]  VARCHAR (6)   NULL,
    [remision]     VARCHAR (10)  NULL,
    [importe]      MONEY         NULL,
    [confirmada]   BIT           NULL,
    [intento]      INT           NULL,
    [msg_error]    VARCHAR (255) NULL,
    [archivo_xml]  VARCHAR (MAX) NULL,
    [codigoWeb]    VARCHAR (50)  NULL
);


GO

