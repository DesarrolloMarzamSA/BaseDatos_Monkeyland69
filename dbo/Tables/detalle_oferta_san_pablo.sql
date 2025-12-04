CREATE TABLE [dbo].[detalle_oferta_san_pablo] (
    [linea]                 INT           NULL,
    [numero_pet_oferta]     VARCHAR (30)  NOT NULL,
    [fecha_peticion_oferta] VARCHAR (30)  NULL,
    [fecha_plazo_entrega]   VARCHAR (30)  NULL,
    [item]                  VARCHAR (30)  NULL,
    [articulo]              VARCHAR (30)  NOT NULL,
    [ean]                   VARCHAR (30)  NOT NULL,
    [unidad_medida]         VARCHAR (30)  NULL,
    [cantidad]              NUMERIC (18)  NOT NULL,
    [descripcion]           VARCHAR (250) NULL,
    CONSTRAINT [PK_detalle_oferta_san_pablo] PRIMARY KEY CLUSTERED ([numero_pet_oferta] ASC, [articulo] ASC, [ean] ASC, [cantidad] ASC) WITH (FILLFACTOR = 90)
);


GO

