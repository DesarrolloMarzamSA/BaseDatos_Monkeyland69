CREATE TABLE [dbo].[pedidos_esquivar] (
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
    [orden]                    BIGINT       NOT NULL,
    [hash_md5]                 VARCHAR (50) NOT NULL,
    [fecha_pedido]             DATETIME     CONSTRAINT [DF_pedidos_esquivar_fecha_pedido] DEFAULT (getdate()) NOT NULL,
    [hora_resp_tandem]         DATETIME     NULL,
    [rftp]                     DATETIME     NULL,
    [tftp]                     DATETIME     NULL,
    [enviado_ftp]              CHAR (10)    NULL,
    [x_dummy]                  CHAR (7)     NULL,
    [porcentaje]               MONEY        NULL,
    [descto_prod]              MONEY        NULL,
    [prec_farm]                MONEY        NULL,
    CONSTRAINT [PK_pedidos_esquivar] PRIMARY KEY CLUSTERED ([cliente] ASC, [cod_barras] ASC, [cant_ped] ASC, [arch_cliente] ASC, [orden] ASC, [hash_md5] ASC, [fecha_pedido] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [cant_surt_ind]
    ON [dbo].[pedidos_esquivar]([cant_surt] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [hora_resp_tandem_ind]
    ON [dbo].[pedidos_esquivar]([hora_resp_tandem] ASC);


GO

CREATE NONCLUSTERED INDEX [sucursal_ind]
    ON [dbo].[pedidos_esquivar]([sucursal] ASC);


GO

CREATE NONCLUSTERED INDEX [tftp_ind]
    ON [dbo].[pedidos_esquivar]([tftp] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [enviado_ftp_ind]
    ON [dbo].[pedidos_esquivar]([enviado_ftp] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [arch_tandem_ind]
    ON [dbo].[pedidos_esquivar]([arch_tandem] ASC);


GO

CREATE NONCLUSTERED INDEX [codigo_ind]
    ON [dbo].[pedidos_esquivar]([codigo] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [tamano_archivo_respuesta_ind]
    ON [dbo].[pedidos_esquivar]([tamano_archivo_respuesta] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [rftp_ind]
    ON [dbo].[pedidos_esquivar]([rftp] ASC);


GO

