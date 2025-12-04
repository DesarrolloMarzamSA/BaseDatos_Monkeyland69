CREATE TABLE [dbo].[cat_productos_torres] (
    [cod_barras]  VARCHAR (20)  NOT NULL,
    [cod_torres]  VARCHAR (10)  NULL,
    [descripcion] VARCHAR (100) NULL,
    [unidad]      VARCHAR (7)   NULL,
    [cod_mar]     VARCHAR (7)   NULL,
    [timestamp]   SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([cod_barras] ASC)
);


GO

