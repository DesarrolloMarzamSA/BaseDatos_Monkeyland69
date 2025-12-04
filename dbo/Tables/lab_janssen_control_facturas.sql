CREATE TABLE [dbo].[lab_janssen_control_facturas] (
    [TotalRegistros] INT        NOT NULL,
    [SumaEAN]        FLOAT (53) NOT NULL,
    [SumaCantidad]   MONEY      NOT NULL,
    [SumaPrecio]     MONEY      NOT NULL,
    [SumaValor]      MONEY      NOT NULL,
    PRIMARY KEY CLUSTERED ([TotalRegistros] ASC, [SumaEAN] ASC, [SumaCantidad] ASC, [SumaPrecio] ASC, [SumaValor] ASC) WITH (FILLFACTOR = 90)
);


GO

