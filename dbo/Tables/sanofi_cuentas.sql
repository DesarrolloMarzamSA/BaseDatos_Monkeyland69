CREATE TABLE [dbo].[sanofi_cuentas] (
    [sucursal] TINYINT     NOT NULL,
    [cliente]  VARCHAR (5) NOT NULL,
    [cufa]     VARCHAR (7) NOT NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [cufa] ASC)
);


GO

