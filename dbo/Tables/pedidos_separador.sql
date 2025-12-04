CREATE TABLE [dbo].[pedidos_separador] (
    [hash_md5]              VARCHAR (50) NOT NULL,
    [sucursal]              TINYINT      NOT NULL,
    [cliente]               VARCHAR (5)  NOT NULL,
    [origen]                VARCHAR (1)  NULL,
    [cod_cred]              VARCHAR (3)  NULL,
    [orden]                 VARCHAR (9)  NULL,
    [licitacion]            VARCHAR (16) NULL,
    [contrato]              VARCHAR (16) NULL,
    [fianza]                VARCHAR (18) NULL,
    [codigo]                VARCHAR (25) NOT NULL,
    [cant_ped]              INT          NULL,
    [cant_surt]             INT          NULL,
    [prec_farm]             MONEY        NULL,
    [motivo_no_surtido]     CHAR (1)     NULL,
    [numero_linea]          INT          NOT NULL,
    [archivo_original]      VARCHAR (15) NOT NULL,
    [archivo]               VARCHAR (15) NULL,
    [fecha_pedido]          DATETIME     NULL,
    [fecha_ped_separacion]  DATETIME     NULL,
    [fecha_respuesta]       DATETIME     NULL,
    [fecha_resp_separacion] DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([hash_md5] ASC, [sucursal] ASC, [cliente] ASC, [codigo] ASC, [numero_linea] ASC, [archivo_original] ASC) WITH (FILLFACTOR = 90)
);


GO

