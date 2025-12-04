CREATE TABLE [dbo].[estados] (
    [cve_estado]  INT          NOT NULL,
    [descripcion] VARCHAR (50) NOT NULL,
    [abreviacion] VARCHAR (10) NULL,
    [sanofi]      CHAR (3)     NULL,
    PRIMARY KEY CLUSTERED ([cve_estado] ASC) WITH (FILLFACTOR = 90)
);


GO

