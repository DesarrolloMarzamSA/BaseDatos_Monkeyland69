CREATE TABLE [dbo].[tmp_objs_desarrollos_inventario] (
    [interfaz]       VARCHAR (50)  NOT NULL,
    [destino]        VARCHAR (20)  NOT NULL,
    [name]           VARCHAR (200) NOT NULL,
    [id]             INT           NOT NULL,
    [fecha_creacion] DATETIME      NULL,
    [clase_objeto]   VARCHAR (30)  NOT NULL,
    [desarrollador]  VARCHAR (30)  NULL,
    [orden]          INT           NULL,
    PRIMARY KEY CLUSTERED ([interfaz] ASC, [name] ASC, [clase_objeto] ASC, [id] ASC) WITH (FILLFACTOR = 90)
);


GO

