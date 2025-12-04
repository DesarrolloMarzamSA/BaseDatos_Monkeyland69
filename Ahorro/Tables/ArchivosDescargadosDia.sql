CREATE TABLE [Ahorro].[ArchivosDescargadosDia] (
    [Id]            INT         IDENTITY (1, 1) NOT NULL,
    [year]          VARCHAR (4) NOT NULL,
    [mes]           VARCHAR (4) NOT NULL,
    [dia]           VARCHAR (4) NOT NULL,
    [diaSemana]     VARCHAR (4) NOT NULL,
    [TotalArchivos] BIGINT      NOT NULL,
    CONSTRAINT [PK_ArchivosDescargadosDia] PRIMARY KEY CLUSTERED ([year] ASC, [mes] ASC, [dia] ASC)
);


GO

