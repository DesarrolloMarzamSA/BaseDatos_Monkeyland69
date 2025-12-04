CREATE TABLE [dbo].[bitacora_envio_fe_cfd] (
    [sucursal]     INT          NULL,
    [serie_cfd]    VARCHAR (2)  NOT NULL,
    [folio_fiscal] VARCHAR (8)  NOT NULL,
    [registro]     DATETIME     NULL,
    [entregada]    BIT          NULL,
    [confirmacion] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([serie_cfd] ASC, [folio_fiscal] ASC)
);


GO

