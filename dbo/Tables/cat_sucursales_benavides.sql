CREATE TABLE [dbo].[cat_sucursales_benavides] (
    [cliente_ibs] VARCHAR (6)   NULL,
    [frontera]    BIT           CONSTRAINT [DF_cat_sucursales_benavides_frontera] DEFAULT ((0)) NOT NULL,
    [cia]         VARCHAR (4)   NOT NULL,
    [mostrador]   VARCHAR (4)   NOT NULL,
    [descripcion] VARCHAR (150) NULL,
    [sucursal]    TINYINT       NOT NULL,
    [cuenta]      VARCHAR (5)   NOT NULL,
    [fecha_alta]  DATE          NULL,
    [franquicia]  VARCHAR (20)  NULL,
    [ibs_letra]   CHAR (1)      NULL,
    [controlados] BIT           CONSTRAINT [DF_cat_sucursales_benavides_controlado] DEFAULT ((0)) NULL,
    [activo]      BIT           CONSTRAINT [DF_cat_sucursales_benavides_activo] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__cat_sucursales_b__76177A41] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC)
);


GO

