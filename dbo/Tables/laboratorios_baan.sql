CREATE TABLE [dbo].[laboratorios_baan] (
    [cod_lab]   VARCHAR (4)  NOT NULL,
    [lab_corto] VARCHAR (16) NOT NULL,
    [lab_largo] VARCHAR (50) NULL,
    [timestamp] DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([cod_lab] ASC) WITH (FILLFACTOR = 90)
);


GO

