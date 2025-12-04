CREATE TABLE [dbo].[detalle_superisste] (
    [SUCURSAL]            INT              NOT NULL,
    [SERIE]               VARCHAR (10)     NOT NULL,
    [IDCUNO]              CHAR (11)        NOT NULL,
    [IDINVN]              NUMERIC (12)     NOT NULL,
    [FACTURA]             VARCHAR (24)     NOT NULL,
    [IDLINE]              NUMERIC (5)      NOT NULL,
    [IDPRDC]              CHAR (35)        NOT NULL,
    [PCXPRC]              NUMERIC (13)     NULL,
    [IDDESC]              CHAR (50)        NOT NULL,
    [IDQTY]               NUMERIC (15, 3)  NOT NULL,
    [CF]                  CHAR (5)         NOT NULL,
    [FARMACIA]            NUMERIC (17, 4)  NOT NULL,
    [UNITARIO]            NUMERIC (17, 4)  NOT NULL,
    [PRECIO_CANTIDAD]     NUMERIC (17, 4)  NOT NULL,
    [NETO_UNITARIO]       NUMERIC (31, 15) NOT NULL,
    [NETO_CANTIDAD]       NUMERIC (17, 4)  NOT NULL,
    [IVA]                 NUMERIC (16, 3)  NULL,
    [IEPS]                NUMERIC (13, 3)  NOT NULL,
    [IEPS_MONEDA]         NUMERIC (31, 23) NULL,
    [TOTAL_IEPS]          NUMERIC (31, 23) NULL,
    [IVA_MONEDA]          NUMERIC (31, 26) NULL,
    [TOTAL_FINAL]         NUMERIC (31, 27) NULL,
    [FECHAPROG]           DATETIME2 (7)    NULL,
    [DESCUENTOPROD]       NUMERIC (16, 5)  NULL,
    [FECHA_ACTUALIZACION] DATETIME         NULL,
    [NOPEDIDO]            VARCHAR (300)    NULL,
    [ESTATUSH]            INT              NULL,
    [ESTATUSD]            INT              NULL,
    [FECHAESTATUS]        DATETIME         NULL,
    CONSTRAINT [PK__detalle___519904D046C859D2] PRIMARY KEY CLUSTERED ([SUCURSAL] ASC, [IDINVN] ASC, [IDLINE] ASC, [SERIE] ASC, [IDPRDC] ASC, [IDQTY] ASC) WITH (FILLFACTOR = 90)
);


GO

