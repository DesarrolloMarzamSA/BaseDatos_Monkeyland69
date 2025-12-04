CREATE TABLE [dbo].[gdl_abc_catalogo] (
    [codigo]         CHAR (7)     NOT NULL,
    [cod_barras]     CHAR (13)    NULL,
    [cod_barras_abc] VARCHAR (13) NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_gdl_abc_catalogo1]
    ON [dbo].[gdl_abc_catalogo]([cod_barras] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_gdl_abc_catalogo2]
    ON [dbo].[gdl_abc_catalogo]([cod_barras_abc] ASC) WITH (FILLFACTOR = 90);


GO

