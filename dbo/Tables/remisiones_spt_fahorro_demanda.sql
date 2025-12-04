CREATE TABLE [dbo].[remisiones_spt_fahorro_demanda] (
    [archivo] VARCHAR (60)  NOT NULL,
    [detalle] VARCHAR (200) NOT NULL,
    PRIMARY KEY CLUSTERED ([archivo] ASC, [detalle] ASC) WITH (FILLFACTOR = 90)
);


GO

