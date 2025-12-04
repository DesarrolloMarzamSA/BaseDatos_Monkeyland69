CREATE TABLE [dbo].[TBL_CambiaFolioAdenda] (
    [CFA_Cliente]             VARCHAR (14)  CONSTRAINT [DF_TBL_CambiaFolioAdenda_CFA_Cliente] DEFAULT ((0)) NOT NULL,
    [CFA_RFC]                 VARCHAR (15)  CONSTRAINT [DF_TBL_CambiaFolioAdenda_CFA_RFC] DEFAULT ((0)) NOT NULL,
    [CFA_Serie]               VARCHAR (5)   NULL,
    [CFA_Folio_Anterior]      VARCHAR (15)  CONSTRAINT [DF_TBL_CambiaFolioAdenda_CFA_Folio_Anterior] DEFAULT ((0)) NOT NULL,
    [CFA_Fecha_Registro]      DATETIME      NOT NULL,
    [CFA_Folio_Nuevo]         VARCHAR (15)  CONSTRAINT [DF_TBL_CambiaFolioAdenda_CFA_Folio_Nuevo] DEFAULT ((0)) NOT NULL,
    [CFA_Estatus]             VARCHAR (5)   CONSTRAINT [DF_TBL_CambiaFolioAdenda_Estatus_Actualizado] DEFAULT ((0)) NULL,
    [CFA_Fecha_Actualizacion] DATETIME      NULL,
    [CFA_Reproceso]           NUMERIC (18)  CONSTRAINT [DF_TBL_CambiaFolioAdenda_CFA_Reproceso] DEFAULT ((0)) NOT NULL,
    [CFA_Fecha_Reproceso]     DATETIME      NULL,
    [CFA_Observaciones]       VARCHAR (100) NULL
);


GO

