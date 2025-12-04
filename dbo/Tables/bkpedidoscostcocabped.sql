CREATE TABLE [dbo].[bkpedidoscostcocabped] (
    [id_pedido]    VARCHAR (12) NOT NULL,
    [clave1]       VARCHAR (8)  NOT NULL,
    [nodo]         VARCHAR (3)  NULL,
    [funcion]      VARCHAR (3)  NULL,
    [numped]       VARCHAR (15) NOT NULL,
    [fecha]        VARCHAR (12) NULL,
    [fechare]      VARCHAR (12) NULL,
    [contaccomp]   VARCHAR (35) NULL,
    [fechacan]     VARCHAR (12) NULL,
    [partdealm]    VARCHAR (15) NOT NULL,
    [refnumint]    VARCHAR (35) NULL,
    [categoria]    VARCHAR (35) NULL,
    [fecha_pedido] DATETIME     NULL
);


GO

