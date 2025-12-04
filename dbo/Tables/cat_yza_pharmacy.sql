CREATE TABLE [dbo].[cat_yza_pharmacy] (
    [sucursal]  TINYINT      NOT NULL,
    [cliente]   VARCHAR (5)  NOT NULL,
    [mostrador] VARCHAR (10) NULL,
    [timestamp] DATETIME     NULL,
    CONSTRAINT [PK_cat_yza_pharmacy] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

