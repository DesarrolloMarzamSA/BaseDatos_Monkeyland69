CREATE TABLE [dbo].[bitacora_comercial_cfd] (
    [bcc_idBitacora]    INT            IDENTITY (1, 1) NOT NULL,
    [bcc_sucursal]      INT            NULL,
    [bcc_serie_cfd]     VARCHAR (4)    NULL,
    [bcc_factura]       VARCHAR (20)   NULL,
    [bcc_folio_fiscal]  VARCHAR (20)   NULL,
    [bcc_fecha_factura] DATE           NULL,
    [bcc_archivo]       VARCHAR (50)   NULL,
    [bcc_estatus]       VARCHAR (50)   NULL,
    [bcc_msg_error]     VARCHAR (2000) NULL,
    PRIMARY KEY NONCLUSTERED ([bcc_idBitacora] ASC) WITH (FILLFACTOR = 100)
);


GO

