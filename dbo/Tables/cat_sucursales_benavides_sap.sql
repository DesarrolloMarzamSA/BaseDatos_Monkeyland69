CREATE TABLE [dbo].[cat_sucursales_benavides_sap] (
    [cliente_ibs] NVARCHAR (10) NOT NULL,
    [frontera]    INT           NOT NULL,
    [cia]         NVARCHAR (60) NULL,
    [mostrador]   VARCHAR (4)   NOT NULL,
    [descripcion] VARCHAR (3)   NOT NULL,
    [sucursal]    NVARCHAR (4)  NOT NULL,
    [cuenta]      NVARCHAR (10) NOT NULL,
    [fecha_alta]  DATETIME      NOT NULL,
    [franquicia]  VARCHAR (9)   NOT NULL,
    [ibs_letra]   VARCHAR (1)   NOT NULL,
    [controlados] INT           NOT NULL,
    [activo]      INT           NOT NULL,
    CONSTRAINT [PK_cat_sucursales_benavides_sap] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC)
);


GO

