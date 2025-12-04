CREATE TABLE [dbo].[devoluciones_hh_seguridad] (
    [UserName]      VARCHAR (30) NOT NULL,
    [pwd]           VARCHAR (30) NULL,
    [sucursal]      TINYINT      NOT NULL,
    [LastLoginDate] DATETIME     NULL,
    [LastLoginIP]   VARCHAR (30) NULL,
    PRIMARY KEY CLUSTERED ([UserName] ASC, [sucursal] ASC) WITH (FILLFACTOR = 90)
);


GO

