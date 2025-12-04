CREATE TABLE [dbo].[CatTiendasFenix] (
    [sucursal]  TINYINT       NOT NULL,
    [cliente]   CHAR (5)      NOT NULL,
    [numTienda] VARCHAR (7)   NULL,
    [nombre]    VARCHAR (100) NULL,
    [calle]     VARCHAR (100) NULL,
    [numero]    VARCHAR (30)  NULL,
    [colonia]   VARCHAR (50)  NULL,
    [ciudad]    VARCHAR (50)  NULL,
    [estado]    VARCHAR (50)  NULL,
    [formato]   VARCHAR (30)  NULL,
    [activa]    TINYINT       NULL,
    [compania]  INT           NULL,
    [region]    VARCHAR (10)  NULL,
    [timestamp] SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([cliente] ASC, [sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_fenix_numTienda]
    ON [dbo].[CatTiendasFenix]([numTienda] ASC) WITH (FILLFACTOR = 90);


GO

