CREATE TABLE [dbo].[rutas_pedidos_AS400] (
    [letra]            VARCHAR (1)  NOT NULL,
    [sucursal]         TINYINT      NOT NULL,
    [interfase]        VARCHAR (30) NULL,
    [ip]               VARCHAR (30) NULL,
    [usuario]          VARCHAR (30) NULL,
    [password]         VARCHAR (30) NULL,
    [volumen]          VARCHAR (30) NULL,
    [fact_elec]        VARCHAR (30) NULL,
    [respuestas]       VARCHAR (30) NULL,
    [dbcopi]           VARCHAR (30) NULL,
    [dbdevols]         VARCHAR (30) NULL,
    [ofertas]          VARCHAR (30) NULL,
    [programa_ofertas] VARCHAR (50) NULL,
    [facturacion]      VARCHAR (30) NULL,
    [catalogos_bi]     VARCHAR (30) NULL,
    [devols_fahorro]   VARCHAR (30) NULL,
    [devoluciones_hh]  VARCHAR (30) NULL,
    CONSTRAINT [PK_rutas_pedidos_AS400] PRIMARY KEY CLUSTERED ([sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

