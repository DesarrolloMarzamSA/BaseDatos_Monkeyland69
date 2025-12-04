CREATE TABLE [IEmbarque].[producto_EAN] (
    [ID]                  INT          IDENTITY (1, 1) NOT NULL,
    [PCIPRC]              VARCHAR (35) NOT NULL,
    [PCXPRC]              VARCHAR (35) NOT NULL,
    [PGDESC]              VARCHAR (50) NULL,
    [PGSTAT]              VARCHAR (5)  NULL,
    [FECHA_ACTUALIZACION] DATETIME     CONSTRAINT [DF_producto_EAN_FECHA_ACTUALIZACION] DEFAULT (getdate()) NULL,
    [FECHA_REGISTRO]      DATETIME     NULL,
    CONSTRAINT [PK_producto_EAN] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230505-165733]
    ON [IEmbarque].[producto_EAN]([PCIPRC] ASC, [PCXPRC] ASC, [PGSTAT] ASC);


GO

