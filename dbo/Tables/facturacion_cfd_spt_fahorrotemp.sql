CREATE TABLE [dbo].[facturacion_cfd_spt_fahorrotemp] (
    [codigos]           CHAR (9)     NOT NULL,
    [descripcion]       VARCHAR (30) NULL,
    [cod_barras]        VARCHAR (13) NULL,
    [laboratorio]       VARCHAR (16) NULL,
    [cant_ped]          INT          NULL,
    [clas_fis]          CHAR (2)     NULL,
    [desc_base]         MONEY        NULL,
    [cant_ofert]        INT          NULL,
    [porcentaje]        MONEY        NULL,
    [prec_pub]          MONEY        NULL,
    [def_iva]           MONEY        NULL,
    [prec_farm]         MONEY        NULL,
    [descto]            MONEY        NULL,
    [total]             MONEY        NULL,
    [grupo_estadistico] VARCHAR (10) NULL,
    [cant_base]         INT          NULL,
    [ieps]              MONEY        NOT NULL,
    [ivaieps]           MONEY        NOT NULL,
    [ieps_porcentaje]   MONEY        NOT NULL,
    [codigoSAT]         VARCHAR (20) NOT NULL,
    [iva_pesos]         MONEY        NULL,
    [porcentajePesos]   MONEY        NULL,
    [totalBruto]        MONEY        NULL
);


GO

