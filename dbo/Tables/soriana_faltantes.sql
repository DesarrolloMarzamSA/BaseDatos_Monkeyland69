CREATE TABLE [dbo].[soriana_faltantes] (
    [fecha]             SMALLDATETIME NULL,
    [documento_soriana] VARCHAR (100) NOT NULL,
    [sucursal]          INT           NULL,
    [serie_cfd]         VARCHAR (2)   NULL,
    [folio_fiscal]      INT           NULL,
    [folio_acuse]       INT           NULL,
    [numTienda]         INT           NULL,
    PRIMARY KEY CLUSTERED ([documento_soriana] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_sor_fal_ser_ff]
    ON [dbo].[soriana_faltantes]([serie_cfd] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_sor_fal_suc_ff]
    ON [dbo].[soriana_faltantes]([sucursal] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90);


GO

