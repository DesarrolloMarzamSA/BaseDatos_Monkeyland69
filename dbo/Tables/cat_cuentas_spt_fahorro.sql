CREATE TABLE [dbo].[cat_cuentas_spt_fahorro] (
    [cuenta_estilo_ahorro] VARCHAR (9) NOT NULL,
    [sucursal_remision]    TINYINT     NULL,
    [cuenta_remision]      VARCHAR (5) NULL,
    [sucursal_factura]     TINYINT     NULL,
    [cuenta_factura]       VARCHAR (5) NULL,
    [cedis]                TINYINT     CONSTRAINT [DF_cat_cuentas_spt_fahorro_cedis] DEFAULT ((0)) NOT NULL,
    [timestamp]            DATETIME    CONSTRAINT [DF__cat_cuent__times__0623C4D8] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK__cat_cuentas_spt___052FA09F] PRIMARY KEY CLUSTERED ([cuenta_estilo_ahorro] ASC) WITH (FILLFACTOR = 90)
);


GO

