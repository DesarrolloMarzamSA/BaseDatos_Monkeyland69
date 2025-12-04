CREATE TABLE [dbo].[catalogoYzaFarmacon] (
    [cliente]          VARCHAR (7)  NOT NULL,
    [cuentaVerificado] VARCHAR (10) NOT NULL,
    [sucursal]         INT          NULL,
    [ctepadre]         VARCHAR (5)  NULL,
    CONSTRAINT [PK_catalogoYzaFarmacon] PRIMARY KEY CLUSTERED ([cliente] ASC, [cuentaVerificado] ASC) WITH (FILLFACTOR = 90)
);


GO

