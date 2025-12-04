CREATE TABLE [dbo].[fenix_solicitadas] (
    [fechaprog]    DATE          NULL,
    [sucursal]     INT           NOT NULL,
    [folio_fiscal] VARCHAR (8)   NOT NULL,
    [solicitud]    DATE          NULL,
    [orden]        INT           IDENTITY (1, 1) NOT NULL,
    [cliente]      VARCHAR (6)   NULL,
    [serie_cfd]    CHAR (2)      NULL,
    [farmacia]     CHAR (39)     NULL,
    [notes]        VARCHAR (100) NULL,
    [lineas]       INT           NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO

