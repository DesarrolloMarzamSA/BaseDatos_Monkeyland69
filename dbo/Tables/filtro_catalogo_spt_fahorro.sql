CREATE TABLE [dbo].[filtro_catalogo_spt_fahorro] (
    [sucursal]    INT          NOT NULL,
    [codigo]      VARCHAR (7)  NOT NULL,
    [cod_barras]  VARCHAR (13) NOT NULL,
    [descripcion] VARCHAR (30) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [codigo] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

