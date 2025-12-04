CREATE TABLE [dbo].[notas_inclusiones_exclusiones_productos] (
    [parametro_beneficios] INT      NOT NULL,
    [codigo]               CHAR (7) NOT NULL,
    [inclusion_exclusion]  BIT      NULL,
    PRIMARY KEY CLUSTERED ([parametro_beneficios] ASC, [codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

