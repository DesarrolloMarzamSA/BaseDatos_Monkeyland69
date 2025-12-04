CREATE TABLE [dbo].[CargaFacturasAhorro] (
    [ohsurf]    VARCHAR (50) NOT NULL,
    [procesado] INT          CONSTRAINT [DF_CargaFacturasAhorro_procesado] DEFAULT ((0)) NOT NULL,
    [proceso]   INT          NULL
);


GO

