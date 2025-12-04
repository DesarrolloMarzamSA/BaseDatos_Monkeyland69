CREATE TABLE [dbo].[tmp_estadisticas_usp_samayoa] (
    [fecha_hora] DATETIME      NOT NULL,
    [usp]        VARCHAR (100) NOT NULL,
    [registros]  INT           NOT NULL,
    [ejecución]  DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([fecha_hora] ASC) WITH (FILLFACTOR = 90)
);


GO

