CREATE TABLE [fbena].[PedidosTransmitidos] (
    [id_pedido]    INT           IDENTITY (1, 1) NOT NULL,
    [nombre]       VARCHAR (100) NULL,
    [rutalocal]    VARCHAR (600) NOT NULL,
    [rutaserver]   VARCHAR (600) NOT NULL,
    [enviado]      BIT           NULL,
    [fechaenvio]   DATETIME      NULL,
    [fechaingreso] DATETIME      NULL,
    [aplicacion]   VARCHAR (50)  NULL,
    [compania]     VARCHAR (15)  NULL,
    [error]        VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id_pedido] ASC)
);


GO

