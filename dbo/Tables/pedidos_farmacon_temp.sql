CREATE TABLE [dbo].[pedidos_farmacon_temp] (
    [sucursal]                   TINYINT      NULL,
    [cuenta]                     VARCHAR (7)  NOT NULL,
    [cod_barras]                 VARCHAR (13) NOT NULL,
    [cantidad_pedida]            INT          NOT NULL,
    [cantidad_surtida]           INT          NULL,
    [motivo_no_surtido]          INT          NULL,
    [tamano_archivo_respuesta]   MONEY        NULL,
    [codigo]                     VARCHAR (7)  NULL,
    [arch_cliente]               VARCHAR (50) NOT NULL,
    [arch_tandem]                VARCHAR (8)  NULL,
    [nombre]                     VARCHAR (50) NOT NULL,
    [orden]                      BIGINT       NOT NULL,
    [hash_md5]                   VARCHAR (50) NOT NULL,
    [pOferta]                    MONEY        NULL,
    [pDescuento]                 MONEY        NULL,
    [pIVA]                       MONEY        NULL,
    [PrecioBaseF]                MONEY        NULL,
    [IndicadorFG]                CHAR (2)     NULL,
    [FechaPedido]                DATETIME     NOT NULL,
    [hora_resp_tandem]           DATETIME     NULL,
    [num_pedido]                 VARCHAR (12) NULL,
    [rftp]                       DATETIME     NULL,
    [tftp]                       DATETIME     NULL,
    [enviado_ftp]                CHAR (10)    NULL,
    [porcentaje_oferta_dboferta] MONEY        NULL,
    [factura]                    VARCHAR (8)  NULL,
    [motivonosurtido_preibs]     VARCHAR (50) NULL
);


GO

