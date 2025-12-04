CREATE TABLE [funion].[PedidosTransmitidos] (
    [id_pedido]    INT           IDENTITY (1, 1) NOT NULL,
    [nombre]       VARCHAR (100) NULL,
    [rutalocal]    VARCHAR (600) NOT NULL,
    [rutaserver]   VARCHAR (600) NOT NULL,
    [enviado]      BIT           NULL,
    [fechaenvio]   DATETIME      NULL,
    [fechaingreso] DATETIME      DEFAULT (getdate()) NULL,
    [aplicacion]   VARCHAR (50)  DEFAULT ('FarmaciasUnion') NULL,
    [compania]     VARCHAR (5)   NULL,
    [error]        VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id_pedido] ASC)
);


GO

