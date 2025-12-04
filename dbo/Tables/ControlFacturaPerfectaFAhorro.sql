CREATE TABLE [dbo].[ControlFacturaPerfectaFAhorro] (
    [Id]              INT             IDENTITY (1, 1) NOT NULL,
    [Periodo]         INT             NOT NULL,
    [OrdenEjecucion]  TINYINT         NOT NULL,
    [IdProceso]       INT             NOT NULL,
    [IdEstado]        TINYINT         NOT NULL,
    [Mensaje]         VARCHAR (250)   NULL,
    [Usuario]         VARCHAR (20)    NULL,
    [Intento]         TINYINT         CONSTRAINT [DF__ControlFa__Inten__2AF94F87] DEFAULT ((0)) NOT NULL,
    [TotalFAhorro]    DECIMAL (18, 2) CONSTRAINT [DF__ControlFa__Total__2BED73C0] DEFAULT ((0)) NOT NULL,
    [TotalMarzam]     DECIMAL (18, 2) CONSTRAINT [DF__ControlFa__Total__2CE197F9] DEFAULT ((0)) NOT NULL,
    [Diferencia]      AS              ([TotalMarzam]-[TotalFAhorro]),
    [UltimaEjecucion] DATETIME        CONSTRAINT [DF__ControlFa__Ultim__2DD5BC32] DEFAULT (getdate()) NOT NULL,
    [FechaRegistro]   DATETIME        CONSTRAINT [DF__ControlFa__Fecha__2EC9E06B] DEFAULT (getdate()) NULL,
    [Procesar]        BIT             CONSTRAINT [DF__ControlFa__Proce__2FBE04A4] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tbl_ControlFacturaPerfectaFAhorro] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [idx_ControlFacturaPerfectaFAhorro_IdProceso_Procesar_IdEstado]
    ON [dbo].[ControlFacturaPerfectaFAhorro]([IdProceso] ASC, [Procesar] ASC, [IdEstado] ASC);


GO

