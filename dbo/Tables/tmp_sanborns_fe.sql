CREATE TABLE [dbo].[tmp_sanborns_fe] (
    [solicitud]    DATE     DEFAULT (getdate()) NULL,
    [serie_cfd]    CHAR (2) NOT NULL,
    [folio_fiscal] CHAR (8) NOT NULL,
    PRIMARY KEY CLUSTERED ([serie_cfd] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO

