CREATE TABLE [dbo].[usuarioReprocesos] (
    [id]             INT          IDENTITY (1, 1) NOT NULL,
    [usuario]        VARCHAR (50) NULL,
    [acceso]         VARCHAR (50) NULL,
    [contrasena]     VARCHAR (50) NULL,
    [fecha_registro] DATETIME     NULL,
    CONSTRAINT [PK_usuarioReprocesos] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);


GO

