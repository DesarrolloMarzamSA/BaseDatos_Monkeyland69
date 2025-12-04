CREATE TABLE [dbo].[bitacora_macro_pedidos] (
    [maquina]         VARCHAR (50) NULL,
    [usuario_windows] VARCHAR (30) NULL,
    [usuario_macro]   VARCHAR (30) NULL,
    [letra]           VARCHAR (1)  NOT NULL,
    [cliente]         VARCHAR (5)  NOT NULL,
    [producto]        VARCHAR (7)  NOT NULL,
    [cantidad]        INT          NOT NULL,
    [timestamp]       DATETIME     NOT NULL,
    [orden]           VARCHAR (16) NULL,
    [archivo]         VARCHAR (10) NULL,
    [cant_surt]       INT          NULL,
    [respondido]      INT          NULL,
    PRIMARY KEY CLUSTERED ([letra] ASC, [cliente] ASC, [producto] ASC, [cantidad] ASC, [timestamp] ASC)
);


GO

