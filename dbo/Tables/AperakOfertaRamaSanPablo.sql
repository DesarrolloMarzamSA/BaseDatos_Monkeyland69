CREATE TABLE [dbo].[AperakOfertaRamaSanPablo] (
    [idRespuesta]    INT           IDENTITY (1, 1) NOT NULL,
    [numeroPeticion] VARCHAR (150) NULL,
    [numeroLineas]   INT           NULL,
    [aperakOferta]   VARCHAR (MAX) NULL,
    [estatus]        VARCHAR (50)  NULL,
    [fechaRegistro]  DATETIME      NULL,
    CONSTRAINT [PK_AperakOfertaRamaSanPablo] PRIMARY KEY CLUSTERED ([idRespuesta] ASC) WITH (FILLFACTOR = 90)
);


GO

