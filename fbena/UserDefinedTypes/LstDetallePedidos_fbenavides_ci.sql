CREATE TYPE [fbena].[LstDetallePedidos_fbenavides_ci] AS TABLE (
    [Linea]           INT           NULL,
    [Cia]             VARCHAR (4)   NULL,
    [Mostrador]       VARCHAR (4)   NULL,
    [CantPedido]      INT           NULL,
    [CodigoBenavides] VARCHAR (18)  NULL,
    [FechaPedido]     VARCHAR (10)  NULL,
    [Pedido]          VARCHAR (10)  NULL,
    [NombreArchivo]   VARCHAR (50)  NULL,
    [Hash_md5]        VARCHAR (150) NULL);


GO

