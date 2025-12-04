CREATE TABLE [dbo].[bitacora] (
    [interfase] VARCHAR (100)  NOT NULL,
    [mensaje]   VARCHAR (1500) NOT NULL,
    [resultado] INT            NOT NULL,
    [folio]     INT            IDENTITY (1, 1) NOT NULL,
    [timestamp] DATETIME       NOT NULL,
    CONSTRAINT [PK__bitacora__4865BE2A] PRIMARY KEY CLUSTERED ([interfase] ASC, [folio] ASC, [timestamp] ASC) WITH (FILLFACTOR = 90)
);


GO

