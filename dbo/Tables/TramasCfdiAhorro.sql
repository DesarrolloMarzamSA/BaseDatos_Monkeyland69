CREATE TABLE [dbo].[TramasCfdiAhorro] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [IdTrama]          VARCHAR (5)    NOT NULL,
    [Posicion]         INT            NOT NULL,
    [CampoMarzam]      VARCHAR (100)  NULL,
    [Alineado]         CHAR (1)       NULL,
    [Longitud]         INT            NULL,
    [ValorPredefinido] VARCHAR (2000) NULL,
    [FechaRegistro]    DATETIME       CONSTRAINT [DF__TramasCfd__Fecha__39C691CB] DEFAULT (getdate()) NULL
);


GO

