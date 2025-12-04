CREATE TABLE [dbo].[cobranza_devols_spt_fahorro] (
    [cliente_spt]      VARCHAR (25)  NULL,
    [remision]         VARCHAR (8)   NULL,
    [motivo]           VARCHAR (8)   NULL,
    [fecha_remision]   DATETIME      NULL,
    [bruto_oferta]     MONEY         NULL,
    [iva]              VARCHAR (25)  NULL,
    [descto_comercial] VARCHAR (25)  NULL,
    [bonificacion]     VARCHAR (25)  NULL,
    [total]            MONEY         NULL,
    [timestamp]        DATETIME      NULL,
    [hash_md5]         VARCHAR (100) NOT NULL,
    [folio]            INT           IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([hash_md5] ASC)
);


GO

