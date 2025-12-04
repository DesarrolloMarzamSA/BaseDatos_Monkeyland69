CREATE TABLE [Ahorro].[resumenPedidos] (
    [year]             INT          NOT NULL,
    [mes]              INT          NOT NULL,
    [dia]              INT          NOT NULL,
    [totalLineas]      INT          NULL,
    [lineasEnviadas]   INT          NULL,
    [lineasFaltantes]  INT          NULL,
    [pedidosTotales]   INT          NULL,
    [pedidosTraductor] INT          NULL,
    [pedidosFaltantes] INT          NULL,
    [diaSemana]        VARCHAR (15) NULL,
    CONSTRAINT [PK_ResumenPedidos] PRIMARY KEY CLUSTERED ([year] ASC, [mes] ASC, [dia] ASC)
);


GO

