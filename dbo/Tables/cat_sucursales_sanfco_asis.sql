CREATE TABLE [dbo].[cat_sucursales_sanfco_asis] (
    [sucursal] INT          NOT NULL,
    [cliente]  VARCHAR (5)  NOT NULL,
    [farmacia] VARCHAR (50) NULL,
    [no_tda]   INT          NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

