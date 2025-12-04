CREATE TABLE [dbo].[devoluciones_spt_fahorro] (
    [devfa_sucursal]                INT          NOT NULL,
    [devfa_fecha_problema]          DATETIME     NULL,
    [devfa_folio_remision]          VARCHAR (8)  NOT NULL,
    [devfa_codigo]                  VARCHAR (7)  NULL,
    [devfa_estatus]                 VARCHAR (2)  NULL,
    [devfa_num_cuenta]              VARCHAR (15) NOT NULL,
    [devfa_pedido]                  VARCHAR (10) NULL,
    [devfa_remision]                VARCHAR (20) NOT NULL,
    [devfa_tipo_reclamacion]        VARCHAR (2)  NOT NULL,
    [devfa_codigo_barras]           VARCHAR (13) NOT NULL,
    [devfa_piezas_teorico]          INT          NULL,
    [devfa_importe_farmacia]        MONEY        NULL,
    [devfa_importe_oferta]          MONEY        NULL,
    [devfa_importe_descto_com]      MONEY        NULL,
    [devfa_iva_total]               MONEY        NULL,
    [devfa_gestor]                  VARCHAR (30) NULL,
    [devfa_autorizacion]            VARCHAR (2)  NULL,
    [devfa_num_movimiento]          VARCHAR (10) NULL,
    [devfa_fecha_interfase]         DATETIME     NULL,
    [devfa_filler2]                 VARCHAR (30) NULL,
    [devfa_fecha_factura]           DATETIME     NULL,
    [devfa_fecha_recepcion]         DATETIME     NULL,
    [devfa_fecha_nota]              DATETIME     NULL,
    [devfa_folio_devol]             VARCHAR (7)  NULL,
    [devfa_pzas_vendidas]           INT          NULL,
    [devfa_pzas_aceptadas]          INT          NULL,
    [devfa_pzas_malestado]          INT          NULL,
    [devfa_pzas_sobrantes]          INT          NULL,
    [devfa_precio_costo]            MONEY        NULL,
    [devfa_precio_farmacia]         MONEY        NULL,
    [devfa_descto_comer_cte]        MONEY        NULL,
    [devfa_pzas_oferta]             INT          NULL,
    [devfa_cantidad_base]           INT          NULL,
    [devfa_cantidad_oferta]         INT          NULL,
    [devfa_porcentaje_oferta]       MONEY        NULL,
    [devfa_importe_devol_real]      MONEY        NULL,
    [devfa_importe_oferta_real]     MONEY        NULL,
    [devfa_importe_descto_com_real] MONEY        NULL,
    [devfa_clasif_fiscal]           VARCHAR (2)  NULL,
    [devfa_descto_comer_prod]       MONEY        NULL,
    [devfa_importe_iva]             MONEY        NULL,
    [devfa_importe_neto]            MONEY        NULL,
    [devfa_fecha_interfase_real]    DATETIME     NULL,
    [devfa_cant_faltante_fact]      INT          NULL,
    [devfa_importe_folio_fact]      MONEY        NULL,
    [devfa_filler1]                 VARCHAR (30) NULL,
    [timestamp]                     DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([devfa_sucursal] ASC, [devfa_folio_remision] ASC, [devfa_codigo_barras] ASC, [devfa_tipo_reclamacion] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_devoluciones_spt_fahorro_devfa_codigo]
    ON [dbo].[devoluciones_spt_fahorro]([devfa_codigo] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_devoluciones_spt_fahorro_devfa_sucursal]
    ON [dbo].[devoluciones_spt_fahorro]([devfa_sucursal] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_devoluciones_spt_fahorro_devfa_fecha_problema]
    ON [dbo].[devoluciones_spt_fahorro]([devfa_fecha_problema] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_devoluciones_spt_fahorro_devfa_tipo_reclamacion]
    ON [dbo].[devoluciones_spt_fahorro]([devfa_tipo_reclamacion] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_devoluciones_spt_fahorro_devfa_folio_remision]
    ON [dbo].[devoluciones_spt_fahorro]([devfa_folio_remision] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_tipo_reclamacion]
    ON [dbo].[devoluciones_spt_fahorro]([devfa_tipo_reclamacion] ASC) WITH (FILLFACTOR = 90);


GO

