CREATE TABLE [dbo].[rutas_farmacon_prueba] (
    [sucursal] TINYINT      NOT NULL,
    [ip]       VARCHAR (20) NOT NULL,
    [usuario]  VARCHAR (20) NULL,
    [password] VARCHAR (20) NULL,
    [ruta]     VARCHAR (50) NULL,
    CONSTRAINT [PK_rutas_farmacon_prueba] PRIMARY KEY CLUSTERED ([sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

