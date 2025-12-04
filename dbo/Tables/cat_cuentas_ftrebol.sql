CREATE TABLE [dbo].[cat_cuentas_ftrebol] (
    [sucursal]    INT          NOT NULL,
    [cliente]     VARCHAR (5)  NOT NULL,
    [descripcion] VARCHAR (50) NULL,
    [mostrador]   INT          NULL,
    [fecha_hora]  DATETIME     NULL,
    [habilitado]  BIT          NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

