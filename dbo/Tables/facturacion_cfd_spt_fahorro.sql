CREATE TABLE [dbo].[facturacion_cfd_spt_fahorro] (
    [sucursal]             INT          NOT NULL,
    [factura]              CHAR (8)     NOT NULL,
    [cuenta_estilo_ahorro] VARCHAR (10) NOT NULL,
    [ruta]                 CHAR (3)     NULL,
    [segto]                CHAR (2)     NULL,
    [ctepadre]             CHAR (3)     NULL,
    [rfc]                  VARCHAR (50) NULL,
    [farmacia]             CHAR (39)    NULL,
    [horacap]              DATETIME     NULL,
    [dueno]                CHAR (30)    NULL,
    [agente]               CHAR (5)     NULL,
    [controlador]          CHAR (2)     NULL,
    [domicilio]            CHAR (40)    NULL,
    [colonia]              CHAR (23)    NULL,
    [poblacion]            CHAR (15)    NULL,
    [codigos]              CHAR (9)     NOT NULL,
    [descripcion]          VARCHAR (30) NULL,
    [cod_barras]           VARCHAR (13) NULL,
    [t_seak]               VARCHAR (16) NULL,
    [cant_real]            SMALLINT     NULL,
    [cant_ped]             SMALLINT     NOT NULL,
    [cant_dev]             SMALLINT     NULL,
    [clas_fis]             CHAR (2)     NULL,
    [cant_base]            SMALLINT     NULL,
    [cant_ofert]           SMALLINT     NULL,
    [porcentaje]           MONEY        NULL,
    [prec_pub]             MONEY        NULL,
    [prec_farm]            MONEY        NULL,
    [desc_base]            MONEY        NULL,
    [def_iva]              MONEY        NULL,
    [grupo_estadistico]    VARCHAR (10) NULL,
    [desctoesp]            CHAR (5)     NULL,
    [descto]               MONEY        NULL,
    [prec_neto]            MONEY        NULL,
    [total]                MONEY        NULL,
    [orden]                VARCHAR (8)  NULL,
    [ahorrado_piezas]      MONEY        NULL,
    [ahorrado_porcentaje]  MONEY        NULL,
    [folio]                CHAR (8)     NULL,
    [fecha_fact]           DATETIME     NULL,
    [tipo_pedido]          VARCHAR (1)  NULL,
    [cliente_tranny]       VARCHAR (5)  NULL,
    [remisionado]          TINYINT      NULL,
    [ieps]                 MONEY        NULL,
    [ivaieps]              MONEY        NULL,
    [ieps_porcentaje]      MONEY        NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [factura] ASC, [codigos] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171107-160355]
    ON [dbo].[facturacion_cfd_spt_fahorro]([factura] ASC, [cuenta_estilo_ahorro] ASC, [ruta] ASC, [ctepadre] ASC, [codigos] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171107-160512]
    ON [dbo].[facturacion_cfd_spt_fahorro]([sucursal] ASC, [factura] ASC, [cuenta_estilo_ahorro] ASC, [codigos] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171107-160440]
    ON [dbo].[facturacion_cfd_spt_fahorro]([sucursal] ASC, [factura] ASC, [cuenta_estilo_ahorro] ASC, [codigos] ASC) WITH (FILLFACTOR = 90);


GO

