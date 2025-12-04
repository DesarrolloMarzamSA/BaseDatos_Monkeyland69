CREATE TABLE [dbo].[lab_janssen_control_pedidos] (
    [TotalRegistros]   INT    NOT NULL,
    [SumaEAN]          BIGINT NOT NULL,
    [SumaCantidad]     INT    NOT NULL,
    [SumaPrecio]       MONEY  NOT NULL,
    [SumaValor]        MONEY  NOT NULL,
    [SumaCantFaltante] INT    NOT NULL,
    PRIMARY KEY CLUSTERED ([TotalRegistros] ASC, [SumaEAN] ASC, [SumaCantidad] ASC, [SumaPrecio] ASC, [SumaValor] ASC, [SumaCantFaltante] ASC) WITH (FILLFACTOR = 90)
);


GO

