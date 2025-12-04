CREATE TABLE [dbo].[TBL_ValoresTXT_CFA] (
    [CFA_Factura]         VARCHAR (15) CONSTRAINT [DF_TBL_ValoresTXT_CFA_CFA_Factura] DEFAULT ((0)) NOT NULL,
    [CFA_Reference]       VARCHAR (15) CONSTRAINT [DF_TBL_ValoresTXT_CFA_CFA_Reference] DEFAULT ((0)) NOT NULL,
    [CFA_Encontrado]      VARCHAR (2)  CONSTRAINT [DF_TBL_ValoresTXT_CFA_CFA_Encontrado] DEFAULT ((0)) NOT NULL,
    [CFA_Fecha_Insercion] DATETIME     NOT NULL
);


GO

