CREATE TABLE [dbo].[CatTiendasWalmart] (
    [sucursal]  TINYINT       NOT NULL,
    [cliente]   CHAR (5)      NOT NULL,
    [numTienda] VARCHAR (5)   NOT NULL,
    [nombre]    VARCHAR (100) NULL,
    [calle]     VARCHAR (100) NULL,
    [numero]    VARCHAR (30)  NULL,
    [colonia]   VARCHAR (50)  NULL,
    [ciudad]    VARCHAR (50)  NULL,
    [estado]    VARCHAR (50)  NULL,
    [formato]   VARCHAR (30)  NULL,
    [activa]    TINYINT       NULL,
    [soap]      INT           NULL,
    [opcion]    INT           NULL,
    [gln]       VARCHAR (14)  NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [numTienda] ASC) WITH (FILLFACTOR = 90)
);


GO

