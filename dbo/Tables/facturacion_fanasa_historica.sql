CREATE TABLE [dbo].[facturacion_fanasa_historica] (
    [IDINVN]         VARCHAR (15)    NOT NULL,
    [FACTURA]        VARCHAR (24)    NOT NULL,
    [IDCUNO]         VARCHAR (11)    NOT NULL,
    [IDIDAT]         VARCHAR (11)    NOT NULL,
    [IDPRDC]         VARCHAR (35)    NOT NULL,
    [IDSALP]         VARCHAR (19)    NOT NULL,
    [IDSQTY]         INT             NOT NULL,
    [DESC_COMERCIAL] NUMERIC (31, 2) NULL,
    [IBS_ORNO]       VARCHAR (15)    NOT NULL,
    [OHSURF]         VARCHAR (35)    NOT NULL,
    [SERIE]          VARCHAR (10)    NULL,
    [IDAREA]         VARCHAR (3)     NOT NULL,
    [NOZ3LENT]       VARCHAR (3)     NOT NULL,
    [HORAFACTURA]    DATETIME2 (7)   NOT NULL,
    [PJEANP]         VARCHAR (14)    NOT NULL,
    [NACOUN]         VARCHAR (4)     NOT NULL
);


GO

