CREATE TABLE [dbo].[hashes_md5] (
    [programa]       VARCHAR (150) NOT NULL,
    [firma]          VARCHAR (150) NOT NULL,
    [fecha]          DATETIME      NOT NULL,
    [nombre_archivo] VARCHAR (200) NULL,
    [lineas]         INT           NULL,
    [tamanio]        INT           NULL,
    [folio_inicial]  INT           NULL,
    [folio_final]    INT           NULL,
    CONSTRAINT [PK__hashes_md5__7B905C75] PRIMARY KEY CLUSTERED ([programa] ASC, [firma] ASC, [fecha] ASC) WITH (FILLFACTOR = 90)
);


GO

