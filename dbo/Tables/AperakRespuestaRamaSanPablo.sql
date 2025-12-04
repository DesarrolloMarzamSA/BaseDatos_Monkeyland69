CREATE TABLE [dbo].[AperakRespuestaRamaSanPablo] (
    [idRespuesta]     INT           IDENTITY (1, 1) NOT NULL,
    [numeroOrden]     VARCHAR (150) NULL,
    [fechaOrden]      VARCHAR (150) NULL,
    [hashMd5]         VARCHAR (350) NULL,
    [numeroLineas]    INT           NULL,
    [aperakRespuesta] VARCHAR (MAX) NULL,
    [fechaRegistro]   DATETIME      NULL,
    CONSTRAINT [PK_respuestaAperakRamaSanPablo] PRIMARY KEY CLUSTERED ([idRespuesta] ASC)
);


GO

