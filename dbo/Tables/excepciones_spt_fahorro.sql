CREATE TABLE [dbo].[excepciones_spt_fahorro] (
    [factura] CHAR (8) NOT NULL,
    [incluir] TINYINT  NULL,
    PRIMARY KEY CLUSTERED ([factura] ASC) WITH (FILLFACTOR = 90)
);


GO

