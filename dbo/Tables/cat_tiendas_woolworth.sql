CREATE TABLE [dbo].[cat_tiendas_woolworth] (
    [sucursal]  INT           NOT NULL,
    [cliente]   VARCHAR (5)   NOT NULL,
    [numTienda] VARCHAR (10)  NULL,
    [nombre]    VARCHAR (100) NULL,
    [gln]       VARCHAR (13)  NULL,
    [activa]    BIT           NULL,
    [timestamp] SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

