CREATE TABLE [dbo].[klyns_cat_cuentas] (
    [sucursal]  TINYINT      NOT NULL,
    [cliente]   CHAR (5)     NOT NULL,
    [nodo]      VARCHAR (10) NULL,
    [timestamp] DATETIME     CONSTRAINT [DF__klyns_cat__times__48868512] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_klyns_cat_cuentas] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

