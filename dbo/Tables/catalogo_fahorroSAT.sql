CREATE TABLE [dbo].[catalogo_fahorroSAT] (
    [Idioma]     VARCHAR (5)   NOT NULL,
    [Codigo]     VARCHAR (10)  NOT NULL,
    [Codigo_Sat] VARCHAR (200) NOT NULL,
    [Fecha]      DATETIME      NOT NULL,
    [Estatus]    VARCHAR (1)   NOT NULL,
    [HashCode]   BIGINT        NOT NULL,
    CONSTRAINT [PK_catalogoSat] PRIMARY KEY CLUSTERED ([Codigo] ASC, [Codigo_Sat] ASC, [HashCode] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171107-155805]
    ON [dbo].[catalogo_fahorroSAT]([Codigo] ASC, [Codigo_Sat] ASC);


GO

