CREATE TABLE [dbo].[lab_janssen_control_movimientos_inventarios] (
    [Id_Movimiento]  VARCHAR (30)    NOT NULL,
    [TotalRegistros] INT             NOT NULL,
    [SumaEAN]        BIGINT          NOT NULL,
    [SumaCantidad]   DECIMAL (12, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Movimiento] ASC)
);


GO

