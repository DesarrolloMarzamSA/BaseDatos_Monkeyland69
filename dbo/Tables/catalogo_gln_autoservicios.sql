CREATE TABLE [dbo].[catalogo_gln_autoservicios] (
    [id]            INT          IDENTITY (1, 1) NOT NULL,
    [descripcion]   VARCHAR (50) NOT NULL,
    [gln_base]      VARCHAR (13) NOT NULL,
    [ctepadre]      VARCHAR (3)  NULL,
    [tabla_tiendas] VARCHAR (70) NOT NULL,
    [fecha_alta]    DATE         NOT NULL,
    [usr]           VARCHAR (3)  NOT NULL
);


GO

