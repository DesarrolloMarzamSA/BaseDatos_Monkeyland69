CREATE TABLE [dbo].[ConsolaCasaLey] (
    [IdPrograma]       INT          IDENTITY (2, 1) NOT NULL,
    [Programa]         VARCHAR (50) NOT NULL,
    [EstatusEjecucion] INT          NOT NULL,
    CONSTRAINT [PK_ConsolaCasaLey] PRIMARY KEY CLUSTERED ([IdPrograma] ASC) WITH (FILLFACTOR = 90)
);


GO

