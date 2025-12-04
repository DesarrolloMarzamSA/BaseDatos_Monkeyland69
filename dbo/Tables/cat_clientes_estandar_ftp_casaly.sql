CREATE TABLE [dbo].[cat_clientes_estandar_ftp_casaly] (
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
    [timestamp]         DATETIME     NULL,
    [selex]             INT          NULL,
    [descripcion]       VARCHAR (50) NULL,
    [id]                INT          NULL,
    [mae]               BIT          NULL,
    [ofe]               BIT          NULL,
    [cam]               BIT          NULL,
    [ped]               BIT          NULL,
    [fee]               BIT          NULL,
    [cliente]           VARCHAR (6)  NULL,
    [ctepadre]          VARCHAR (6)  NULL
);


GO

