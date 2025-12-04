CREATE TABLE [dbo].[pedidos_pharmacy_floresRegalos_historia] (
    [sucursal]                              TINYINT       NULL,
    [cliente]                               VARCHAR (5)   NOT NULL,
    [cod_barras]                            VARCHAR (13)  NOT NULL,
    [cant_ped]                              INT           NOT NULL,
    [cant_surt]                             INT           NULL,
    [motivo_no_surtido]                     INT           NULL,
    [tamano_archivo_respuesta]              MONEY         NULL,
    [codigo]                                VARCHAR (7)   NULL,
    [arch_cliente]                          VARCHAR (350) NOT NULL,
    [arch_tandem]                           VARCHAR (350) NULL,
    [orden]                                 VARCHAR (50)  NOT NULL,
    [hash_md5]                              VARCHAR (50)  NOT NULL,
    [fecha_pedido]                          SMALLDATETIME NOT NULL,
    [hora_resp_tandem]                      SMALLDATETIME NULL,
    [rftp]                                  SMALLDATETIME NULL,
    [tftp]                                  SMALLDATETIME NULL,
    [enviado_ftp]                           CHAR (10)     NULL,
    [factura]                               VARCHAR (8)   NULL,
    [piezas_sin_cargo]                      VARCHAR (10)  NULL,
    [precio_farmacia_sin_iva]               VARCHAR (10)  NULL,
    [importe_descuento_oferta_unitario]     VARCHAR (10)  NULL,
    [importe_descuento_financiero_unitario] VARCHAR (10)  NULL,
    [fechahistoria]                         SMALLDATETIME NOT NULL
);


GO

