CREATE TABLE [dbo].[cuentas_transfer] (
    [sucursal]    TINYINT  NOT NULL,
    [suc_destino] TINYINT  NULL,
    [cliente]     CHAR (5) NOT NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

