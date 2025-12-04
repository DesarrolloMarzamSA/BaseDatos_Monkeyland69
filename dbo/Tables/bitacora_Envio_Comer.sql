CREATE TABLE [dbo].[bitacora_Envio_Comer] (
    [idarchivo]      INT           IDENTITY (1, 1) NOT NULL,
    [destinoArchivo] VARCHAR (350) NULL,
    [archivo]        VARCHAR (350) NULL,
    [hostName]       VARCHAR (350) NULL,
    [usuario]        VARCHAR (350) NULL,
    [fechaEnvio]     DATETIME      NULL,
    CONSTRAINT [PK_bitacoraEnvioComer] PRIMARY KEY CLUSTERED ([idarchivo] ASC) WITH (FILLFACTOR = 90)
);


GO

