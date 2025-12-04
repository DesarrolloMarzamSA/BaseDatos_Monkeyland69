CREATE TABLE [dbo].[lab_janssen_control_stock_distribucion] (
    [TotalRegistros] INT             NOT NULL,
    [SumaEAN]        BIGINT          NOT NULL,
    [SumaCantidad]   DECIMAL (12, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([TotalRegistros] ASC, [SumaEAN] ASC, [SumaCantidad] ASC) WITH (FILLFACTOR = 90)
);


GO

