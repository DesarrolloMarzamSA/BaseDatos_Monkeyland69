CREATE TABLE [dbo].[rutas_pedidos_yza] (
    [sucursal]          TINYINT      NOT NULL,
    [nombre]            VARCHAR (50) NOT NULL,
    [email]             VARCHAR (50) NULL,
    [ip]                VARCHAR (20) NULL,
    [usuario]           VARCHAR (20) NULL,
    [password]          VARCHAR (20) NULL,
    [ruta]              VARCHAR (50) NULL,
    [hora_inicio]       VARCHAR (12) NULL,
    [hora_fin]          VARCHAR (12) NULL,
    [activo]            TINYINT      NULL,
    [filtro_monto]      TINYINT      NULL,
    [limite_filtro_min] MONEY        NULL,
    [limite_filtro_max] MONEY        NULL,
    [timestamp]         DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [nombre] ASC) WITH (FILLFACTOR = 90)
);


GO

