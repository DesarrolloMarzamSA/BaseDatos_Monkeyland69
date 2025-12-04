CREATE TABLE [dbo].[issste_codigos_en_demanda_web] (
    [codigo]    CHAR (7) NOT NULL,
    [timestamp] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC)
);


GO

