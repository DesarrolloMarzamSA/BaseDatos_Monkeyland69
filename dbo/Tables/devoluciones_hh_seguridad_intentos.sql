CREATE TABLE [dbo].[devoluciones_hh_seguridad_intentos] (
    [id]          SMALLINT     IDENTITY (1, 1) NOT NULL,
    [IP]          VARCHAR (30) NULL,
    [Username]    VARCHAR (30) NULL,
    [Success]     TINYINT      NULL,
    [dateentered] DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);


GO

