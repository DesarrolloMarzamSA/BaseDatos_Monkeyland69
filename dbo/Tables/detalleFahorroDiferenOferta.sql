CREATE TABLE [dbo].[detalleFahorroDiferenOferta] (
    [SUCURSAL]              INT             NOT NULL,
    [SERIE]                 VARCHAR (10)    NULL,
    [IDCUNO]                VARCHAR (11)    NOT NULL,
    [NANCA1]                VARCHAR (12)    NULL,
    [IDINVN]                NUMERIC (12)    NOT NULL,
    [FACTURA]               VARCHAR (24)    NOT NULL,
    [IDLINE]                NUMERIC (5)     NOT NULL,
    [IDPRDC]                VARCHAR (50)    NOT NULL,
    [PCXPRC]                NUMERIC (13)    NULL,
    [IDDESC]                VARCHAR (50)    NOT NULL,
    [IDQTY]                 NUMERIC (15, 3) NOT NULL,
    [FARMACIA]              NUMERIC (18, 4) NOT NULL,
    [precFarmaAhorro]       MONEY           NULL,
    [DTDCPR]                NUMERIC (13, 2) NOT NULL,
    [porcentajOfertaAhorro] MONEY           NULL,
    [DESCOFERTA]            VARCHAR (50)    NULL,
    [importOfertaAhorro]    MONEY           NULL,
    [DESCCOMERCIAL]         VARCHAR (15)    NULL,
    [DescComercialPesos]    VARCHAR (50)    NULL
);


GO

