CREATE TABLE [dbo].[catalogo_productos_funion] (
    [sucursal]                 INT         NOT NULL,
    [codigo]                   VARCHAR (7) NOT NULL,
    [aplica_cast_caduc]        VARCHAR (2) NULL,
    [porc_cast_caduc]          INT         NULL,
    [porc_convenio_lab_extra]  DECIMAL (7) NULL,
    [porc_bonif_nl]            DECIMAL (5) NULL,
    [aplica_castigo_caducidad] BIT         NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

