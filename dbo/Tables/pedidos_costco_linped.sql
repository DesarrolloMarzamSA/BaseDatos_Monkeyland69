CREATE TABLE [dbo].[pedidos_costco_linped] (
    [id_pedido]    VARCHAR (12) NOT NULL,
    [clave1]       VARCHAR (8)  NOT NULL,
    [clave2]       VARCHAR (6)  NOT NULL,
    [refean]       VARCHAR (17) NOT NULL,
    [cantped]      INT          NOT NULL,
    [cmonetaria]   MONEY        NULL,
    [nacargo1]     VARCHAR (3)  NULL,
    [refcli]       VARCHAR (35) NULL,
    [umedida]      VARCHAR (3)  NULL,
    [numpacint]    MONEY        NULL,
    [fecha_pedido] DATETIME     NULL,
    CONSTRAINT [PK_pedidos_costco_linped] PRIMARY KEY CLUSTERED ([id_pedido] ASC, [clave1] ASC, [clave2] ASC, [refean] ASC) WITH (FILLFACTOR = 90)
);


GO

