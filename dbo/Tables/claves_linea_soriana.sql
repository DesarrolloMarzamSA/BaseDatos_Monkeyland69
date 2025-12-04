CREATE TABLE [dbo].[claves_linea_soriana] (
    [cod_barras]    VARCHAR (13) NOT NULL,
    [descripcion]   VARCHAR (50) NULL,
    [clave_linea]   VARCHAR (2)  NULL,
    [linea_soriana] VARCHAR (4)  NULL,
    PRIMARY KEY CLUSTERED ([cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

