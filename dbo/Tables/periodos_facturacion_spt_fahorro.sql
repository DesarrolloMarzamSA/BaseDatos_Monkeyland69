CREATE TABLE [dbo].[periodos_facturacion_spt_fahorro] (
    [id]      INT      NOT NULL,
    [inicio]  DATETIME NULL,
    [termino] DATETIME NULL,
    [activo]  INT      DEFAULT (0) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);


GO

