CREATE TABLE [dbo].[sucursales] (
    [sucursal]       TINYINT      NOT NULL,
    [descripcion]    VARCHAR (20) NULL,
    [letra]          VARCHAR (1)  NULL,
    [razon_social]   VARCHAR (30) NULL,
    [IATA]           VARCHAR (4)  NULL,
    [virtual]        TINYINT      NULL,
    [almacen]        TINYINT      NULL,
    [AZM]            VARCHAR (1)  NULL,
    [ibs]            VARCHAR (4)  NULL,
    [porcentaje_iva] MONEY        NULL,
    [suc_interdata]  TINYINT      NULL,
    [serie]          VARCHAR (1)  NULL,
    [serie_cfd]      VARCHAR (2)  NULL,
    [gln]            VARCHAR (14) NULL,
    [sucursal_hh]    TINYINT      NULL,
    [id_traductor]   VARCHAR (5)  NULL,
    [ibs_letra]      CHAR (1)     NULL,
    [almacen_ibs]    CHAR (3)     NULL,
    [compania_baan]  CHAR (3)     NULL,
    [letra_baan]     CHAR (1)     NULL,
    [sistema]        VARCHAR (10) NULL,
    [serie_cfd_old]  VARCHAR (2)  NULL,
    [fecha_ibs]      DATE         NULL,
    [fisica]         BIT          DEFAULT ((0)) NULL,
    [fecha_fusion]   DATE         NULL,
    [serie_cfd_nc]   CHAR (2)     NULL,
    [dwh]            CHAR (2)     NULL,
    [ftp412_home]    VARCHAR (10) NULL,
    [horario]        INT          NULL,
    [frontera]       BIT          DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC)
);


GO

