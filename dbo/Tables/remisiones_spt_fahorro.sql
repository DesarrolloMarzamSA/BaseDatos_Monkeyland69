CREATE TABLE [dbo].[remisiones_spt_fahorro] (
    [archivo] VARCHAR (50)  NOT NULL,
    [detalle] VARCHAR (150) NOT NULL,
    PRIMARY KEY CLUSTERED ([archivo] ASC, [detalle] ASC) WITH (FILLFACTOR = 90)
);


GO

