CREATE TABLE [dbo].[segmentos] (
    [segto]       VARCHAR (2)   NOT NULL,
    [ctepadre]    VARCHAR (3)   NOT NULL,
    [descripcion] VARCHAR (100) NULL,
    [timestamp]   DATETIME      DEFAULT (getdate()) NULL,
    [monitorear]  BIT           DEFAULT ((0)) NULL,
    [orden]       INT           DEFAULT ((999)) NULL,
    [n_corto]     CHAR (10)     NULL,
    PRIMARY KEY CLUSTERED ([segto] ASC, [ctepadre] ASC) WITH (FILLFACTOR = 90)
);


GO

