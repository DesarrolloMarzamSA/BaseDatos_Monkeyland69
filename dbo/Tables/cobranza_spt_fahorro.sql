CREATE TABLE [dbo].[cobranza_spt_fahorro] (
    [cliente_spt]     VARCHAR (25)  NOT NULL,
    [factura]         CHAR (8)      NOT NULL,
    [fecha]           DATETIME      NOT NULL,
    [total_neto]      MONEY         NULL,
    [remision]        VARCHAR (25)  NOT NULL,
    [fecha_remision]  DATETIME      NULL,
    [monto_baan]      MONEY         NULL,
    [neto_peds_ok]    MONEY         NULL,
    [total_iva]       MONEY         NULL,
    [total_descuento] MONEY         NULL,
    [hash_md5]        VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([cliente_spt] ASC, [factura] ASC, [fecha] ASC, [remision] ASC, [hash_md5] ASC)
);


GO

