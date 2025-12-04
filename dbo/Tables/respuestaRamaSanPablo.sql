CREATE TABLE [dbo].[respuestaRamaSanPablo] (
    [sucursal]        INT          NULL,
    [cliente]         VARCHAR (50) NOT NULL,
    [ean]             VARCHAR (50) NOT NULL,
    [cantidadSurtida] NUMERIC (18) NOT NULL,
    [numeroPedido]    VARCHAR (50) NOT NULL,
    [filler]          VARCHAR (50) NULL,
    [codigoMarzam]    VARCHAR (50) NULL,
    [filler1]         VARCHAR (50) NULL,
    [filler2]         VARCHAR (50) NULL,
    [nombreArchivo]   VARCHAR (50) NOT NULL,
    [fechaRegistro]   DATETIME     CONSTRAINT [DF_respuestaRamaSanPablo_fechaRegistro] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_respuestaRamaSanPablo] PRIMARY KEY CLUSTERED ([cliente] ASC, [ean] ASC, [cantidadSurtida] ASC, [numeroPedido] ASC, [nombreArchivo] ASC) WITH (FILLFACTOR = 90)
);


GO

