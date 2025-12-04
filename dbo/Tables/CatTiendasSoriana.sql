CREATE TABLE [dbo].[CatTiendasSoriana] (
    [cliente_ibs] CHAR (6)      NULL,
    [ibs_letra]   CHAR (1)      NULL,
    [sucursal]    TINYINT       NOT NULL,
    [cliente]     CHAR (5)      NOT NULL,
    [frontera]    BIT           CONSTRAINT [DF_CatTiendasSoriana_frontera] DEFAULT ((0)) NULL,
    [numTienda]   VARCHAR (5)   NOT NULL,
    [nombre]      VARCHAR (100) NULL,
    [calle]       VARCHAR (100) NULL,
    [numero]      VARCHAR (30)  NULL,
    [colonia]     VARCHAR (50)  NULL,
    [ciudad]      VARCHAR (50)  NULL,
    [estado]      VARCHAR (50)  NULL,
    [formato]     VARCHAR (30)  NULL,
    [activa]      TINYINT       NULL,
    [opcion]      INT           NULL,
    [gln]         VARCHAR (14)  NULL,
    [gln_old]     VARCHAR (14)  NULL,
    [timestamp]   DATETIME      NULL,
    [usr]         VARCHAR (10)  NULL,
    CONSTRAINT [PK__CatTiendasSorian__395884C4] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [numTienda] ASC) WITH (FILLFACTOR = 90)
);


GO

