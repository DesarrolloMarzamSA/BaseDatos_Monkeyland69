CREATE TABLE [dbo].[politicas_devolucion] (
    [sucursal]          TINYINT     NOT NULL,
    [codigo]            VARCHAR (7) NOT NULL,
    [acepta_devolucion] BIT         NULL,
    [leyenda_id]        INT         NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [fk_leyenda_id] FOREIGN KEY ([leyenda_id]) REFERENCES [dbo].[leyendas_politicas_devolucion] ([leyenda_id])
);


GO

