CREATE TABLE [dbo].[pedidos_spt_fahorro_traductor] (
    [HSROM]      CHAR (3)     NOT NULL,
    [HNCA1]      CHAR (6)     NOT NULL,
    [HCUNO]      CHAR (11)    NOT NULL,
    [HARCHIVO]   CHAR (50)    NOT NULL,
    [HFECHA]     CHAR (15)    NOT NULL,
    [HINVN]      NUMERIC (12) NOT NULL,
    [HORNO]      NUMERIC (12) NOT NULL,
    [HORDS]      NUMERIC (2)  NOT NULL,
    [HPRODUCTOS] NUMERIC (15) NOT NULL,
    [HCLIENTE]   CHAR (30)    NOT NULL,
    [HMAPA]      CHAR (15)    NOT NULL,
    [HREGPEDI]   NUMERIC (8)  NOT NULL,
    [HPZAPEDI]   NUMERIC (8)  NOT NULL,
    [HREGFACT]   NUMERIC (8)  NOT NULL,
    [HPZAFACT]   NUMERIC (8)  NOT NULL,
    [HREGDIFE]   NUMERIC (8)  NOT NULL,
    [HPZADIFE]   NUMERIC (8)  NOT NULL,
    [HPEDIDOS]   NUMERIC (4)  NOT NULL,
    [HSTATUS]    CHAR (10)    NOT NULL,
    [HRESPUES]   CHAR (2)     NOT NULL,
    [HPRMS1]     CHAR (20)    NOT NULL,
    [HTIPO]      CHAR (15)    NOT NULL,
    [HCIA]       CHAR (10)    NOT NULL,
    [HFECHAPRO]  CHAR (15)    NOT NULL,
    [HPRCN]      CHAR (10)    NOT NULL,
    [HUSER]      CHAR (30)    NOT NULL
);


GO

