CREATE TABLE [dbo].[archivo_manual_muguerza] (
    [idArchivo]     INT           IDENTITY (1, 1) NOT NULL,
    [archivo]       VARCHAR (30)  NULL,
    [rutaArchivo]   VARCHAR (MAX) NULL,
    [serie]         VARCHAR (50)  NULL,
    [folioFiscal]   VARCHAR (50)  NULL,
    [importe]       MONEY         NULL,
    [estatus]       INT           NULL,
    [fechaRegistro] DATETIME      NULL,
    CONSTRAINT [PK_archivo_manual_muguerza] PRIMARY KEY CLUSTERED ([idArchivo] ASC) WITH (FILLFACTOR = 90)
);


GO

