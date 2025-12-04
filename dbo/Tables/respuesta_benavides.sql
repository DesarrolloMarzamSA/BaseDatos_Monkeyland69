CREATE TABLE [dbo].[respuesta_benavides] (
    [hashmd5]        VARCHAR (100) NOT NULL,
    [nombreArchivo]  VARCHAR (100) NOT NULL,
    [fechaRespuesta] DATETIME      NULL,
    [estatus]        INT           NULL,
    CONSTRAINT [PK_respuesta_benavides] PRIMARY KEY CLUSTERED ([hashmd5] ASC, [nombreArchivo] ASC) WITH (FILLFACTOR = 90)
);


GO

