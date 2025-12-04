CREATE TABLE [dbo].[accesos_aplicaciones_desktop] (
    [id]         INT          IDENTITY (1, 1) NOT NULL,
    [aplicacion] VARCHAR (20) NOT NULL,
    [equipo]     VARCHAR (20) NOT NULL,
    [usuario]    VARCHAR (20) NULL,
    [fecha_alta] DATE         NULL,
    PRIMARY KEY CLUSTERED ([aplicacion] ASC, [equipo] ASC) WITH (FILLFACTOR = 90)
);


GO

