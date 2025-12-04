CREATE TABLE [dbo].[pedidosok_spt_fahorro] (
    [nombre_archivo]   VARCHAR (100) NULL,
    [sucursal]         INT           NOT NULL,
    [cliente]          VARCHAR (5)   NOT NULL,
    [cedis]            INT           NULL,
    [orden]            VARCHAR (8)   NOT NULL,
    [status]           VARCHAR (2)   NULL,
    [remision]         VARCHAR (8)   NOT NULL,
    [gestor]           VARCHAR (30)  NULL,
    [costo]            MONEY         NULL,
    [oferta]           MONEY         NULL,
    [pronto_pago]      MONEY         NULL,
    [iva_neto]         MONEY         NULL,
    [fecha_movimiento] DATETIME      NULL,
    [pzas_pedidook]    INT           NULL,
    [fechahora]        DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [orden] ASC, [remision] ASC)
);


GO

