CREATE TABLE [dbo].[pedido_nadro] (
    [sucursal]               INT          NOT NULL,
    [cliente]                VARCHAR (5)  NOT NULL,
    [orden_corta]            VARCHAR (3)  NULL,
    [filler1]                VARCHAR (1)  NULL,
    [orden_completo]         VARCHAR (15) NULL,
    [fecha_generacion_nadro] DATETIME     NULL,
    [cod_barras]             VARCHAR (15) NOT NULL,
    [codigo]                 VARCHAR (7)  NULL,
    [cantidad]               INT          NOT NULL,
    [cantidad_surtida]       INT          NULL,
    [nombre_archivo_cte]     VARCHAR (15) NOT NULL,
    [fecha_insertado]        DATETIME     NOT NULL,
    [fecha_tandem]           DATETIME     NULL,
    [fecha_resp]             DATETIME     NULL,
    [arch_tandem]            VARCHAR (8)  NULL,
    [hash_md5_arch_cliente]  VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [cod_barras] ASC, [cantidad] ASC, [nombre_archivo_cte] ASC, [fecha_insertado] ASC, [hash_md5_arch_cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_pedido_nadro_cod_barras]
    ON [dbo].[pedido_nadro]([cod_barras] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pedido_nadro_orden]
    ON [dbo].[pedido_nadro]([orden_completo] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pedido_nadro_fecha_resp]
    ON [dbo].[pedido_nadro]([fecha_resp] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pedido_nadro_arch_tandem]
    ON [dbo].[pedido_nadro]([arch_tandem] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pedido_nadro_md5]
    ON [dbo].[pedido_nadro]([hash_md5_arch_cliente] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_pedido_nadro_fecha_tandem]
    ON [dbo].[pedido_nadro]([fecha_tandem] ASC) WITH (FILLFACTOR = 90);


GO

