CREATE TABLE [dbo].[lab_sanofi2_control_transfer_sucursal] (
    [TotalRegistros] INT             NOT NULL,
    [SumaEAN]        BIGINT          NOT NULL,
    [SumaCantidad]   DECIMAL (12, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([TotalRegistros] ASC, [SumaEAN] ASC, [SumaCantidad] ASC)
);


GO

