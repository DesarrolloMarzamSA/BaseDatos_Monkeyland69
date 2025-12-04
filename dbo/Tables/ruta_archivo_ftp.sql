CREATE TABLE [dbo].[ruta_archivo_ftp] (
    [idRutas]    INT           IDENTITY (1, 1) NOT NULL,
    [ftp]        VARCHAR (150) NULL,
    [usuario]    VARCHAR (50)  NULL,
    [contrasena] VARCHAR (50)  NULL,
    [ruta]       VARCHAR (350) NULL,
    [cliente]    VARCHAR (50)  NULL,
    [rutaInfo]   VARCHAR (350) NULL,
    CONSTRAINT [PK_ruta_archivo_ftp] PRIMARY KEY CLUSTERED ([idRutas] ASC)
);


GO

