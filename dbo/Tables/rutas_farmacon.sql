CREATE TABLE [dbo].[rutas_farmacon] (
    [sucursal] TINYINT      NOT NULL,
    [ip]       VARCHAR (20) NOT NULL,
    [usuario]  VARCHAR (20) NULL,
    [password] VARCHAR (20) NULL,
    [ruta]     VARCHAR (50) NULL,
    CONSTRAINT [PK_rutas_farmacon] PRIMARY KEY CLUSTERED ([sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

