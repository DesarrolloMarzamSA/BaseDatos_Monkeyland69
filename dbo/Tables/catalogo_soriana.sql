CREATE TABLE [dbo].[catalogo_soriana] (
    [cod_barras]  VARCHAR (13) NULL,
    [codigo]      VARCHAR (7)  NOT NULL,
    [descripcion] VARCHAR (35) NULL,
    [prec_farm]   MONEY        NULL,
    [prec_pub]    MONEY        NULL,
    [clas_ssa]    VARCHAR (2)  NULL,
    [clas_fis]    VARCHAR (2)  NULL,
    [refrigerado] CHAR (1)     NULL,
    [lab_rfc]     VARCHAR (16) NULL,
    [grupo_est]   CHAR (6)     NULL,
    [descto_prod] MONEY        NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

