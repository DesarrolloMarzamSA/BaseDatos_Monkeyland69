CREATE TABLE [dbo].[ctrl_folios_hh_documentos_cobranza_eliminados] (
    [serie]     VARCHAR (8)  NOT NULL,
    [folio]     INT          NOT NULL,
    [agen_cod]  VARCHAR (8)  NULL,
    [usuario]   VARCHAR (30) NULL,
    [status]    VARCHAR (10) NULL,
    [timestamp] DATETIME     NULL
);


GO

