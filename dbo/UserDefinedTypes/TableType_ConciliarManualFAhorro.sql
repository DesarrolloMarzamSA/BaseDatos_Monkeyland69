CREATE TYPE [dbo].[TableType_ConciliarManualFAhorro] AS TABLE (
    [Id]                 INT             NOT NULL,
    [SUCURSAL]           INT             NOT NULL,
    [SERIE]              VARCHAR (10)    NULL,
    [IDCUNO]             VARCHAR (11)    NOT NULL,
    [FACTURA]            VARCHAR (24)    NOT NULL,
    [IDLINE]             NUMERIC (5)     NOT NULL,
    [IDPRDC]             VARCHAR (50)    NOT NULL,
    [IDQTY]              NUMERIC (15, 3) NOT NULL,
    [FARMACIA]           NUMERIC (18, 4) NOT NULL,
    [PRECIO_CANTIDAD]    NUMERIC (13, 2) NOT NULL,
    [DESCCOMERCIAL]      VARCHAR (15)    NULL,
    [DESCCOMERCIALPESOS] VARCHAR (50)    NULL,
    [IHOREF]             VARCHAR (35)    NOT NULL,
    [PERIODO]            INT             NULL,
    [RECALCULO]          INT             NULL);


GO

