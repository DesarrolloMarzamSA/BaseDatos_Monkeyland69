CREATE TABLE [dbo].[casaleyarchivos] (
    [Serie]   NVARCHAR (20) NOT NULL,
    [Total]   INT           NOT NULL,
    [Fecha]   NVARCHAR (60) NOT NULL,
    [Carpeta] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_casaleyarchivos] PRIMARY KEY CLUSTERED ([Serie] ASC, [Carpeta] ASC, [Fecha] ASC, [Total] ASC) WITH (FILLFACTOR = 90)
);


GO

