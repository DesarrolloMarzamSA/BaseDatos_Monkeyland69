CREATE TABLE [dbo].[sucursales_labs_automation] (
    [sucursal] INT NOT NULL,
    [az]       INT NULL,
    [promeco]  INT NULL,
    [sanofi]   INT NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

