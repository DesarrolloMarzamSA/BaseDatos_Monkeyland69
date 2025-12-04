CREATE TABLE [dbo].[pedidoRamaSanPablo] (
    [lineaPedido]   INT           NOT NULL,
    [numeroOrden]   VARCHAR (150) NOT NULL,
    [fechaOrden]    VARCHAR (150) NULL,
    [numeroCita]    VARCHAR (150) NOT NULL,
    [fechaCita]     VARCHAR (50)  NULL,
    [horaCita]      VARCHAR (50)  NULL,
    [item]          VARCHAR (50)  NOT NULL,
    [articulo]      VARCHAR (250) NULL,
    [codigoBarras]  VARCHAR (50)  NOT NULL,
    [unidadMedida]  VARCHAR (50)  NULL,
    [cantidad]      DECIMAL (18)  NULL,
    [descripcion]   VARCHAR (350) NULL,
    [precioEFE]     MONEY         NULL,
    [zDE1]          MONEY         NULL,
    [zDE2]          MONEY         NULL,
    [zDE3]          MONEY         NULL,
    [fechaRegistro] DATETIME      NULL,
    [estatus]       INT           NULL,
    [hashMd5]       VARCHAR (350) NOT NULL,
    CONSTRAINT [PK_pedidoRamaSanPablo] PRIMARY KEY CLUSTERED ([lineaPedido] ASC, [numeroOrden] ASC, [numeroCita] ASC, [item] ASC, [codigoBarras] ASC, [hashMd5] ASC)
);


GO

