CREATE TABLE [dbo].[superisste2] (
    [Factura]            VARCHAR (50)    NULL,
    [Tipo]               INT             NULL,
    [Numeroprove]        NVARCHAR (6)    NULL,
    [FolioalternoCosteo] NVARCHAR (40)   NULL,
    [ImporteCosteo]      NVARCHAR (50)   NULL,
    [UUID]               NVARCHAR (60)   NULL,
    [Fecha]              NVARCHAR (20)   NULL,
    [Importesubfactura]  NUMERIC (13, 2) NULL,
    [IEPS]               NVARCHAR (20)   NULL,
    [IVA]                NUMERIC (13, 2) NULL,
    [Importetotalfac]    NUMERIC (13, 2) NULL
);


GO

