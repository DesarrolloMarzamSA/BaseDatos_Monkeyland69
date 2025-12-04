CREATE TABLE [dbo].[bitacora_consulta] (
    [interfase] VARCHAR (100)  NOT NULL,
    [mensaje]   VARCHAR (1500) NOT NULL,
    [resultado] INT            NOT NULL,
    [folio]     INT            IDENTITY (1, 1) NOT NULL,
    [timestamp] DATETIME       NOT NULL,
    CONSTRAINT [PK__bitacora_consult__4A4E069C] PRIMARY KEY CLUSTERED ([interfase] ASC, [folio] ASC, [timestamp] ASC) WITH (FILLFACTOR = 90)
);


GO

