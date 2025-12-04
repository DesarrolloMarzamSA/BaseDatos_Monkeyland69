CREATE TABLE [dbo].[detalle_casaley_xml] (
    [SUCURSAL]            INT             NOT NULL,
    [SERIE]               VARCHAR (10)    NOT NULL,
    [IDCUNO]              CHAR (11)       NOT NULL,
    [IDINVN]              NUMERIC (12)    NOT NULL,
    [FACTURA]             VARCHAR (24)    NOT NULL,
    [IDLINE]              NUMERIC (5)     NOT NULL,
    [IDPRDC]              CHAR (35)       NOT NULL,
    [PCXPRC]              NUMERIC (13)    NULL,
    [IDDESC]              CHAR (50)       NOT NULL,
    [IDQTY]               NUMERIC (15, 3) NOT NULL,
    [CF]                  CHAR (5)        NOT NULL,
    [FARMACIA]            NUMERIC (18, 4) NOT NULL,
    [UNITARIO]            NUMERIC (18, 4) NOT NULL,
    [PRECIO_CANTIDAD]     NUMERIC (13, 2) NOT NULL,
    [NETO_UNITARIO]       NUMERIC (13, 2) NOT NULL,
    [NETO_CANTIDAD]       NUMERIC (13, 2) NOT NULL,
    [IVA]                 NUMERIC (4, 2)  NULL,
    [IEPS]                NUMERIC (13, 2) NOT NULL,
    [IEPS_MONEDA]         NUMERIC (13, 2) NULL,
    [TOTAL_IEPS]          NUMERIC (13, 2) NULL,
    [IVA_MONEDA]          NUMERIC (13, 2) NULL,
    [TOTAL_FINAL]         NUMERIC (13, 2) NULL,
    [FECHAPROG]           DATETIME2 (7)   NULL,
    [DESCUENTOPROD]       NUMERIC (13, 2) NULL,
    [FECHA_ACTUALIZACION] DATETIME        NULL,
    [NOPEDIDO]            VARCHAR (300)   NULL,
    [ESTATUSH]            INT             NULL,
    [ESTATUSD]            INT             NULL,
    [FECHAESTATUS]        DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([SUCURSAL] ASC, [IDINVN] ASC, [IDLINE] ASC, [SERIE] ASC, [IDPRDC] ASC, [IDQTY] ASC) WITH (FILLFACTOR = 90)
);


GO

