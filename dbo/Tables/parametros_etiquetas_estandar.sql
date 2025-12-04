CREATE TABLE [dbo].[parametros_etiquetas_estandar] (
    [nombre]      VARCHAR (25)  NOT NULL,
    [leyenda]     VARCHAR (19)  NULL,
    [descuento]   MONEY         NULL,
    [query]       VARCHAR (250) NULL,
    [direcciones] VARCHAR (250) NULL,
    [timestamp]   DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([nombre] ASC) WITH (FILLFACTOR = 90)
);


GO

