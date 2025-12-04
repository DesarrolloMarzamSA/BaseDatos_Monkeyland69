CREATE TABLE [dbo].[cat_clientes_estandar_ftp] (
    [sucursal]          TINYINT       NOT NULL,
    [nombre]            VARCHAR (50)  NOT NULL,
    [email]             VARCHAR (200) NULL,
    [ip]                VARCHAR (20)  NULL,
    [usuario]           VARCHAR (20)  NULL,
    [password]          VARCHAR (20)  NULL,
    [ruta]              VARCHAR (50)  NULL,
    [hora_inicio]       VARCHAR (12)  NULL,
    [hora_fin]          VARCHAR (12)  NULL,
    [activo]            TINYINT       NULL,
    [filtro_monto]      TINYINT       NULL,
    [limite_filtro_min] MONEY         NULL,
    [limite_filtro_max] MONEY         NULL,
    [timestamp]         DATETIME      CONSTRAINT [DF__cat_clien__times__4ED38FEE] DEFAULT (getdate()) NULL,
    [selex]             INT           NULL,
    [descripcion]       VARCHAR (100) NULL,
    [id]                INT           NULL,
    [mae]               BIT           NULL,
    [ofe]               BIT           NULL,
    [cam]               BIT           NULL,
    [ped]               BIT           NULL,
    [fee]               BIT           NULL,
    [cliente]           VARCHAR (6)   NULL,
    [ctepadre]          VARCHAR (6)   NULL,
    [ticket]            INT           NULL,
    CONSTRAINT [PK__cat_clientes_est__4DDF6BB5] PRIMARY KEY CLUSTERED ([sucursal] ASC, [nombre] ASC) WITH (FILLFACTOR = 90)
);


GO

