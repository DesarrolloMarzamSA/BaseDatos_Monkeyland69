CREATE TABLE [dbo].[lab_sanofi_cat_productos] (
    [codigo]      VARCHAR (7)  NOT NULL,
    [descripcion] VARCHAR (30) NULL,
    [cod_barras]  VARCHAR (13) NULL,
    [clas_fis]    VARCHAR (2)  NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

