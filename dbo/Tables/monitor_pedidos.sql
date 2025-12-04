CREATE TABLE [dbo].[monitor_pedidos] (
    [fecha_hora]         SMALLDATETIME NOT NULL,
    [nombre]             VARCHAR (50)  NOT NULL,
    [ctepadre]           VARCHAR (3)   NOT NULL,
    [cliente_ibs]        VARCHAR (6)   NOT NULL,
    [lineas]             INT           NULL,
    [pzas_solicitado]    INT           NULL,
    [importe_solicitado] MONEY         NULL,
    [pzas_surtidas]      INT           NULL,
    [importe_surtidas]   MONEY         NULL,
    PRIMARY KEY CLUSTERED ([fecha_hora] ASC, [nombre] ASC, [ctepadre] ASC, [cliente_ibs] ASC) WITH (FILLFACTOR = 90)
);


GO

