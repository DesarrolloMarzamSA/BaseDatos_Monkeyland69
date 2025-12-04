CREATE TABLE [dbo].[pedido_comercial_mexicana] (
    [idPedido]      INT           IDENTITY (1, 1) NOT NULL,
    [archivoPedido] VARCHAR (50)  NULL,
    [rutaArchivo]   VARCHAR (MAX) NULL,
    [hostname]      VARCHAR (50)  NULL,
    [hashMD5]       VARCHAR (150) NULL,
    [fechaRegistro] DATETIME      NULL,
    CONSTRAINT [PK_pedido_comercial_mexicana] PRIMARY KEY CLUSTERED ([idPedido] ASC) WITH (FILLFACTOR = 90)
);


GO

