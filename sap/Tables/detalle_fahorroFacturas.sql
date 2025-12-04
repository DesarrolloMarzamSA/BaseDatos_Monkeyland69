CREATE TABLE [sap].[detalle_fahorroFacturas] (
    [IDPRDC]             VARCHAR (50)    NULL,
    [PCXPRC]             VARCHAR (14)    NULL,
    [CODIGOSAT]          VARCHAR (200)   NOT NULL,
    [IDDESC]             VARCHAR (50)    NULL,
    [LABORATORIO]        VARCHAR (16)    NULL,
    [IDQTY]              NUMERIC (38)    NULL,
    [CF]                 VARCHAR (50)    NULL,
    [FARMACIA]           DECIMAL (20, 2) NULL,
    [UNITARIO]           DECIMAL (20, 2) NULL,
    [PUBLICO]            DECIMAL (20, 2) NULL,
    [PRECIO_CANTIDAD]    DECIMAL (38, 2) NULL,
    [NETO_UNITARIO]      DECIMAL (20, 2) NULL,
    [NETO_CANTIDAD]      DECIMAL (38, 2) NULL,
    [IVA]                DECIMAL (20, 2) NULL,
    [IEPS]               DECIMAL (20, 2) NULL,
    [IEPS_MONEDA]        NUMERIC (10, 2) NULL,
    [TOTAL_IEPS]         DECIMAL (38, 2) NULL,
    [IVA_MONEDA]         NUMERIC (10, 2) NULL,
    [TOTAL_FINAL]        DECIMAL (38, 2) NULL,
    [DTDCPR]             NUMERIC (13, 2) NOT NULL,
    [DESCOFERTA]         DECIMAL (38, 2) NULL,
    [DescComercial]      DECIMAL (20, 2) NULL,
    [DescComercialPesos] DECIMAL (38, 2) NULL,
    [NATREG]             VARCHAR (50)    NOT NULL,
    [PERIODO]            INT             NULL
);


GO

