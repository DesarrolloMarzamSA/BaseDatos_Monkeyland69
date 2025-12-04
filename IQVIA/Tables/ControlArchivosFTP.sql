CREATE TABLE [IQVIA].[ControlArchivosFTP] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [NombreArchivo] VARCHAR (30)  NOT NULL,
    [RutaFTP]       VARCHAR (100) NOT NULL,
    [FechaCarga]    DATETIME      NOT NULL,
    [Estatus]       VARCHAR (100) NOT NULL,
    [NoCorrida]     INT           NULL,
    CONSTRAINT [PK_ControlArchivosFTP] PRIMARY KEY CLUSTERED ([NombreArchivo] ASC, [RutaFTP] ASC)
);


GO

