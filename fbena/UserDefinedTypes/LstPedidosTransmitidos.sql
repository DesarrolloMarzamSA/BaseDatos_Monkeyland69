CREATE TYPE [fbena].[LstPedidosTransmitidos] AS TABLE (
    [id_pedido]    INT            NULL,
    [nombre]       VARCHAR (100)  NULL,
    [rutalocal]    VARCHAR (600)  NULL,
    [rutaserver]   VARCHAR (600)  NULL,
    [enviado]      BIT            NULL,
    [fechaenvio]   DATETIME       NULL,
    [fechaingreso] DATETIME       NULL,
    [aplicacion]   VARCHAR (50)   NULL,
    [compania]     VARCHAR (15)   NULL,
    [error]        VARCHAR (2000) NULL);


GO

