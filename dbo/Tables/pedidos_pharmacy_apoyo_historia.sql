CREATE TABLE [dbo].[pedidos_pharmacy_apoyo_historia] (
    [sucursal]                              TINYINT      NULL,
    [cliente]                               VARCHAR (5)  NOT NULL,
    [cod_barras]                            VARCHAR (13) NOT NULL,
    [cant_ped]                              INT          NOT NULL,
    [cant_surt]                             INT          NULL,
    [motivo_no_surtido]                     INT          NULL,
    [tamano_archivo_respuesta]              MONEY        NULL,
    [codigo]                                VARCHAR (7)  NULL,
    [arch_cliente]                          VARCHAR (50) NOT NULL,
    [arch_tandem]                           VARCHAR (50) NULL,
    [orden]                                 VARCHAR (50) NOT NULL,
    [hash_md5]                              VARCHAR (50) NOT NULL,
    [fecha_pedido]                          DATETIME     NOT NULL,
    [hora_resp_tandem]                      DATETIME     NULL,
    [rftp]                                  DATETIME     NULL,
    [tftp]                                  DATETIME     NULL,
    [enviado_ftp]                           CHAR (10)    NULL,
    [factura]                               VARCHAR (8)  NULL,
    [piezas_sin_cargo]                      VARCHAR (10) NULL,
    [precio_farmacia_sin_iva]               VARCHAR (10) NULL,
    [importe_descuento_oferta_unitario]     VARCHAR (10) NULL,
    [importe_descuento_financiero_unitario] VARCHAR (10) NULL,
    [fechahistoria]                         DATETIME     NOT NULL,
    CONSTRAINT [PK_pedidos_pharmacy_apoyo_historia] PRIMARY KEY CLUSTERED ([cliente] ASC, [cod_barras] ASC, [cant_ped] ASC, [arch_cliente] ASC, [orden] ASC, [hash_md5] ASC, [fecha_pedido] ASC, [fechahistoria] ASC)
);


GO

