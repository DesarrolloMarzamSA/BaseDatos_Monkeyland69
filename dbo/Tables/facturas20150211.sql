CREATE TABLE [dbo].[facturas20150211] (
    [SUCURSAL]        INT             NOT NULL,
    [SERIE]           VARCHAR (10)    NULL,
    [IDCUNO]          VARCHAR (11)    NOT NULL,
    [IDINVN]          NUMERIC (12)    NOT NULL,
    [NANAME]          CHAR (30)       NOT NULL,
    [NANSNA]          CHAR (20)       NOT NULL,
    [NANCA1]          CHAR (6)        NOT NULL,
    [FACTURA]         VARCHAR (24)    NOT NULL,
    [IDLINE]          NUMERIC (5)     NOT NULL,
    [IDPRDC]          CHAR (35)       NOT NULL,
    [PCXPRC]          NUMERIC (13)    NULL,
    [IDDESC]          CHAR (50)       NOT NULL,
    [IDQTY]           NUMERIC (15, 3) NOT NULL,
    [CF]              CHAR (5)        NOT NULL,
    [FARMACIA]        NUMERIC (18, 4) NOT NULL,
    [UNITARIO]        NUMERIC (18, 4) NOT NULL,
    [PRECIO_CANTIDAD] NUMERIC (13, 2) NOT NULL,
    [NETO_UNITARIO]   NUMERIC (13, 2) NOT NULL,
    [NETO_CANTIDAD]   NUMERIC (13, 2) NOT NULL,
    [IVA]             NUMERIC (4, 2)  NULL,
    [IEPS]            NUMERIC (13, 2) NOT NULL,
    [IEPS_MONEDA]     NUMERIC (13, 2) NULL,
    [TOTAL_IEPS]      NUMERIC (13, 2) NULL,
    [IVA_MONEDA]      NUMERIC (13, 2) NULL,
    [TOTAL_FINAL]     NUMERIC (13, 2) NULL,
    [FECHAPROG]       DATETIME2 (7)   NOT NULL,
    [IHOREF]          VARCHAR (35)    NOT NULL
);


GO

