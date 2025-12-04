CREATE TABLE [dbo].[catalog_pedidos_clientes_mostradores] (
    [cadena]      VARCHAR (50)  NOT NULL,
    [cliente]     CHAR (6)      NOT NULL,
    [frontera]    BIT           DEFAULT ((0)) NULL,
    [descripcion] VARCHAR (50)  NULL,
    [registro]    SMALLDATETIME DEFAULT (getdate()) NOT NULL,
    [sucursal]    TINYINT       NULL,
    [ibs_letra]   CHAR (1)      NULL,
    [mostrador]   VARCHAR (10)  NULL,
    [cia]         VARCHAR (10)  NULL,
    [franquicia]  VARCHAR (10)  NULL,
    [usr]         CHAR (4)      NOT NULL,
    PRIMARY KEY CLUSTERED ([cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

