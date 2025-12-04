CREATE TABLE [dbo].[bkpedidoscostcolinped] (
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
    [fecha_pedido] DATETIME     NULL
);


GO

