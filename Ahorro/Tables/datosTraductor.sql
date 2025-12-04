CREATE TABLE [Ahorro].[datosTraductor] (
    [hashId]         VARBINARY (255) NOT NULL,
    [cuenta]         VARCHAR (10)    NULL,
    [nombreArchivo]  VARCHAR (30)    NULL,
    [fechaTraductor] DATETIME        NULL,
    [estatus]        INT             NULL,
    CONSTRAINT [PK_DatosTraductor] PRIMARY KEY CLUSTERED ([hashId] ASC)
);


GO

