CREATE TABLE [dbo].[tmp_az_control_movimientos_inventarios_xml] (
    [Id_Movimiento]  VARCHAR (30)    NOT NULL,
    [TotalRegistros] INT             NOT NULL,
    [SumaEAN]        BIGINT          NOT NULL,
    [SumaCantidad]   DECIMAL (12, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Movimiento] ASC) WITH (FILLFACTOR = 90)
);


GO

