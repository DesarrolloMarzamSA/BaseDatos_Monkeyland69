CREATE TABLE [dbo].[cfd_soriana_acuses_de_recibo] (
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
    [addenda]           BIT          CONSTRAINT [DF__cfd_soria__adden__10AC4043] DEFAULT ((0)) NULL,
    [remision]          VARCHAR (10) NULL,
    [reporte]           INT          NULL,
    [pagina]            INT          NULL,
    [linea]             INT          NULL,
    [sucursal]          INT          NULL,
    [cliente]           VARCHAR (6)  NULL,
    [cliente_ibs]       VARCHAR (6)  NULL,
    CONSTRAINT [PK__cfd_sori__57B672320EC3F7D1] PRIMARY KEY CLUSTERED ([numTienda] ASC, [documento_soriana] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_sori_acu_serie_folio]
    ON [dbo].[cfd_soriana_acuses_de_recibo]([serie_cfd] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_sori_acu_f_paqu]
    ON [dbo].[cfd_soriana_acuses_de_recibo]([fecha_paquete] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_sori_acu_tda_fa]
    ON [dbo].[cfd_soriana_acuses_de_recibo]([numTienda] ASC, [folio_acuse] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_sori_acu_f_fact]
    ON [dbo].[cfd_soriana_acuses_de_recibo]([fecha_factura] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_suc_cte]
    ON [dbo].[cfd_soriana_acuses_de_recibo]([sucursal] ASC, [cliente] ASC, [remision] ASC) WITH (FILLFACTOR = 90);


GO

