CREATE TABLE [dbo].[pedidos_farmapronto] (
    [sucursal]                 TINYINT      NULL,
    [cliente]                  VARCHAR (5)  NOT NULL,
    [cod_barras]               VARCHAR (13) NOT NULL,
    [cant_ped]                 INT          NOT NULL,
    [cant_surt]                INT          NULL,
    [motivo_no_surtido]        INT          NULL,
    [tamano_archivo_respuesta] MONEY        NULL,
    [codigo]                   VARCHAR (7)  NULL,
    [arch_cliente]             VARCHAR (50) NOT NULL,
    [arch_tandem]              VARCHAR (8)  NULL,
    [orden]                    VARCHAR (50) NOT NULL,
    [hash_md5]                 VARCHAR (50) NOT NULL,
    [fecha_pedido]             DATETIME     NOT NULL,
    [hora_resp_tandem]         DATETIME     NULL,
    [rftp]                     DATETIME     NULL,
    [tftp]                     DATETIME     NULL,
    [enviado_ftp]              CHAR (10)    NULL,
    [factura]                  VARCHAR (8)  NULL,
    [idproveedor]              CHAR (10)    NULL,
    [fechadelpedido]           NCHAR (10)   NULL,
    CONSTRAINT [PK_pedidos_farmapronto2] PRIMARY KEY CLUSTERED ([cliente] ASC, [cod_barras] ASC, [cant_ped] ASC, [arch_cliente] ASC, [orden] ASC, [hash_md5] ASC, [fecha_pedido] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [IDX_pedidosFarmapronto_IX]
    ON [dbo].[pedidos_farmapronto]([sucursal] ASC, [cliente] ASC, [arch_tandem] ASC, [orden] ASC, [codigo] ASC)
    INCLUDE([arch_cliente], [cant_ped], [cod_barras], [fecha_pedido], [hash_md5]);


GO

