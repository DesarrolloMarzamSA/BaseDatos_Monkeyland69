CREATE TABLE [dbo].[rutas_facturacion_universal] (
    [id]         INT          IDENTITY (1, 1) NOT NULL,
    [sucursal]   INT          NOT NULL,
    [cliente]    VARCHAR (50) NOT NULL,
    [ip]         VARCHAR (50) NULL,
    [usuario]    VARCHAR (50) NULL,
    [contrasena] VARCHAR (50) NULL,
    [ruta]       VARCHAR (50) NULL,
    CONSTRAINT [PK_rutas_facturacion_universal] PRIMARY KEY CLUSTERED ([id] ASC, [sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

