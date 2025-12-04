CREATE TABLE [dbo].[clientes_cufa] (
    [sucursal]  TINYINT      NOT NULL,
    [cliente]   CHAR (5)     NOT NULL,
    [cufa]      VARCHAR (15) NULL,
    [timestamp] DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

