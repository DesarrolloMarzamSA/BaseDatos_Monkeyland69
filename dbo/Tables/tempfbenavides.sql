CREATE TABLE [dbo].[tempfbenavides] (
    [orden]        INT           IDENTITY (1, 1) NOT NULL,
    [serie_cfd]    VARCHAR (2)   NULL,
    [sucursal]     INT           NOT NULL,
    [folio_fiscal] VARCHAR (8)   NOT NULL,
    [fechaprog]    SMALLDATETIME NULL
);


GO

