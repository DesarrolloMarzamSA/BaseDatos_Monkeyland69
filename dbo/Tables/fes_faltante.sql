CREATE TABLE [dbo].[fes_faltante] (
    [sucursal]                    TINYINT       NULL,
    [cliente]                     VARCHAR (5)   NULL,
    [digito_verificador]          CHAR (1)      NULL,
    [serie]                       VARCHAR (1)   NULL,
    [factura]                     CHAR (8)      NULL,
    [fecha_factura]               DATETIME      NULL,
    [codigo]                      VARCHAR (7)   NULL,
    [descripcion]                 VARCHAR (30)  NULL,
    [cod_barras]                  VARCHAR (13)  NULL,
    [clas_fis]                    CHAR (2)      NULL,
    [piezas_surtidas_con_cargo]   INT           NULL,
    [piezas_surtidas_sin_cargo]   INT           NULL,
    [precio_farm_sin_imp]         MONEY         NULL,
    [precio_pub_sin_imp]          MONEY         NULL,
    [precio_pub_con_imp]          MONEY         NULL,
    [importe_bruto]               MONEY         NULL,
    [porcentaje_descto_oferta]    MONEY         NULL,
    [descto_oferta]               MONEY         NULL,
    [porcentaje_descto_comercial] MONEY         NULL,
    [descto_comercial]            MONEY         NULL,
    [ieps]                        MONEY         NULL,
    [iva]                         MONEY         NULL,
    [bonificacion_iva]            MONEY         NULL,
    [porcentaje_utilidad]         MONEY         NULL,
    [importe_neto]                MONEY         NULL,
    [orden]                       VARCHAR (10)  NULL,
    [porcentaje_iva]              MONEY         NULL,
    [filler]                      VARCHAR (5)   NULL,
    [no_registro]                 INT           NULL,
    [desc_comerc_prod]            MONEY         NULL,
    [porcentaje_iva2]             MONEY         NULL,
    [iva2]                        MONEY         NULL,
    [bonificacion_iva2]           MONEY         NULL,
    [porcentaje_ieps]             MONEY         NULL,
    [desc_comerc_ieps]            MONEY         NULL,
    [iva_del_iesps]               MONEY         NULL,
    [bonificacion_iva_del_iesps]  MONEY         NULL,
    [timestamp]                   DATETIME      NULL,
    [segto]                       CHAR (2)      NULL,
    [ctepadre]                    CHAR (3)      NULL,
    [rfc]                         VARCHAR (50)  NULL,
    [tipo_documento]              VARCHAR (1)   NULL,
    [folio_fiscal]                VARCHAR (8)   NULL,
    [fecha_tandem]                SMALLDATETIME NULL
);


GO

CREATE CLUSTERED INDEX [tdx_tmp_fes]
    ON [dbo].[fes_faltante]([sucursal] ASC, [cliente] ASC, [factura] ASC, [codigo] ASC) WITH (FILLFACTOR = 90);


GO

