CREATE TABLE [FRO].[hashes_md5FRO] (
    [programa]       VARCHAR (50)   NOT NULL,
    [firma]          VARCHAR (50)   NOT NULL,
    [fecha]          DATETIME       NOT NULL,
    [nombre_archivo] VARCHAR (100)  NULL,
    [lineas]         INT            NULL,
    [tamanio]        INT            NULL,
    [folio_inicial]  INT            NULL,
    [folio_final]    INT            NULL,
    [BuroCredito]    NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([programa] ASC, [firma] ASC, [fecha] ASC)
);


GO

