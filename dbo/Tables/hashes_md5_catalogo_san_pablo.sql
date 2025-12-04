CREATE TABLE [dbo].[hashes_md5_catalogo_san_pablo] (
    [programa]       VARCHAR (150) NOT NULL,
    [firma]          VARCHAR (150) NOT NULL,
    [fecha]          DATETIME      NOT NULL,
    [nombre_archivo] VARCHAR (200) NULL,
    [lineas]         INT           NULL,
    CONSTRAINT [PK__hashes_md5_catalogo_san_pablo] PRIMARY KEY CLUSTERED ([programa] ASC, [firma] ASC, [fecha] ASC) WITH (FILLFACTOR = 90)
);


GO

