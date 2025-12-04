CREATE TABLE [dbo].[pedidoWalmartConsec] (
    [idpedido]      INT           IDENTITY (1, 1) NOT NULL,
    [nombreArchivo] VARCHAR (350) NULL,
    [hashMD5]       VARCHAR (350) NULL,
    [fechaRegistro] DATETIME      NULL,
    CONSTRAINT [PK_pedidoWalmartConsec] PRIMARY KEY CLUSTERED ([idpedido] ASC) WITH (FILLFACTOR = 90)
);


GO

