CREATE TABLE [dbo].[ControlCargaRemisionesFAhorro] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [Usuario]         VARCHAR (50) NOT NULL,
    [InicioCarga]     DATETIME     NOT NULL,
    [FinCarga]        DATETIME     NOT NULL,
    [IdEstado]        TINYINT      NOT NULL,
    [Intento]         TINYINT      CONSTRAINT [DF_ControlCargaRemisionesFAhorro_Intento] DEFAULT ((1)) NOT NULL,
    [UltimaEjecucion] DATETIME     CONSTRAINT [DF__CargaRemi__Ultim__07B0134A] DEFAULT (getdate()) NULL,
    [FechaRegistro]   DATETIME     CONSTRAINT [DF__CargaRemi__Fecha__08A43783] DEFAULT (getdate()) NULL,
    [Procesar]        BIT          CONSTRAINT [DF_ControlCargaRemisionesFAhorro_BorradoLogico] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_CargaRemisiones] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

