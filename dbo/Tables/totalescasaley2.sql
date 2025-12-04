CREATE TABLE [dbo].[totalescasaley2] (
    [id_total]     INT      IDENTITY (1, 1) NOT NULL,
    [totalbd]      INT      NOT NULL,
    [totalarchivo] INT      NOT NULL,
    [totalftps]    INT      NOT NULL,
    [totalftpr]    INT      NOT NULL,
    [fecha]        DATETIME NULL,
    PRIMARY KEY CLUSTERED ([id_total] ASC) WITH (FILLFACTOR = 90)
);


GO

