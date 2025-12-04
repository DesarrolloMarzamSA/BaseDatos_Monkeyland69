CREATE TABLE [dbo].[CatTiendasFTorres] (
    [sucursal]  INT          NOT NULL,
    [letra]     VARCHAR (1)  NULL,
    [cliente]   VARCHAR (5)  NOT NULL,
    [farmacia]  VARCHAR (50) NULL,
    [mostrador] INT          NULL,
    [activo]    INT          NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

