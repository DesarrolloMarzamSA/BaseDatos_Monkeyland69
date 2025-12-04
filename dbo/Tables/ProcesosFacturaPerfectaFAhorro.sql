CREATE TABLE [dbo].[ProcesosFacturaPerfectaFAhorro] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [OrdenEjecucion]  TINYINT       NOT NULL,
    [Proceso]         VARCHAR (50)  NOT NULL,
    [Descripcion]     VARCHAR (150) NULL,
    [PAntecesor]      INT           NULL,
    [PSucesor]        INT           NULL,
    [ValidaAntecesor] BIT           NULL,
    [ValidaSucesor]   BIT           NULL,
    [FechaRegistro]   DATETIME      NULL,
    [BorradoLogico]   BIT           CONSTRAINT [DF__ProcesosF__Borra__3A3B9317] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tbl_ProcesosFacturaPerfectaFAhorro] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

