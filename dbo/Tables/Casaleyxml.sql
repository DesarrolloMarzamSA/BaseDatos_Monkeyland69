CREATE TABLE [dbo].[Casaleyxml] (
    [id_factura]              INT            IDENTITY (1, 1) NOT NULL,
    [emisor]                  NVARCHAR (100) NULL,
    [tipo]                    NVARCHAR (60)  NULL,
    [uuid]                    NVARCHAR (200) NULL,
    [folio]                   INT            NULL,
    [serie]                   NVARCHAR (20)  NULL,
    [rfcEmisor]               NVARCHAR (200) NULL,
    [rfcReceptor]             NVARCHAR (200) NULL,
    [ValidacionEstructura]    NVARCHAR (200) NULL,
    [ValidacionFoliosCert]    NVARCHAR (200) NULL,
    [ValidacionSello]         NVARCHAR (200) NULL,
    [ValidacionImportes]      NVARCHAR (200) NULL,
    [ValidacionDatosFiscales] NVARCHAR (200) NULL,
    [Fecha]                   DATE           NULL,
    [estatus]                 NVARCHAR (40)  NULL,
    [nombrearchivo]           NVARCHAR (200) NULL,
    CONSTRAINT [PK_Casaleyxml] PRIMARY KEY CLUSTERED ([id_factura] ASC) WITH (FILLFACTOR = 90)
);


GO

