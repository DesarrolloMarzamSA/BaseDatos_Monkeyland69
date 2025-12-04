CREATE TABLE [dbo].[extraccionEmbarqueFarmapronto_] (
    [VWERK]                 VARCHAR (8)     NULL,
    [PARTNE]                VARCHAR (20)    NULL,
    [XBLNR]                 VARCHAR (32)    NULL,
    [VBELN]                 VARCHAR (20)    NULL,
    [FKDAT]                 DATETIME        NULL,
    [POSNR]                 DATETIME        NULL,
    [MATNR]                 BIGINT          NULL,
    [ARKTX]                 VARCHAR (80)    NULL,
    [CHARG]                 VARCHAR (20)    NULL,
    [EAN11]                 VARCHAR (36)    NULL,
    [KONDM]                 VARCHAR (4)     NULL,
    [CANTIDAD]              DECIMAL (13, 3) NULL,
    [PRECIOFARMACIA]        DECIMAL (15, 2) NULL,
    [PRECIO_PUBLICO]        DECIMAL (13, 2) NULL,
    [PRECIO_PUBLICO_IMP]    DECIMAL (13, 2) NULL,
    [IMPORTE_BRUTO]         DECIMAL (13, 2) NULL,
    [PORCENTAJE_OFERTAS]    DECIMAL (13, 2) NULL,
    [OFERTAS]               DECIMAL (13, 2) NULL,
    [PORCENTAJE_DESCUENTOS] DECIMAL (13, 2) NULL,
    [DESCUENTOS]            DECIMAL (13, 2) NULL,
    [IEPS]                  DECIMAL (13, 2) NULL,
    [IVA]                   DECIMAL (13, 2) NULL,
    [IMPORTE_NETO]          DECIMAL (13, 2) NULL,
    [BSTKD]                 VARCHAR (70)    NULL,
    [PORC_TMX1]             DECIMAL (10, 2) NULL,
    [PORC_TMX2]             DECIMAL (10, 2) NULL,
    [IND_SECTOR]            VARCHAR (20)    NULL,
    [KNRZE]                 VARCHAR (20)    NULL,
    [TAXNUM]                VARCHAR (40)    NULL,
    [IDNUMBER]              VARCHAR (120)   NULL,
    [ALTKN]                 VARCHAR (20)    NULL
);


GO

