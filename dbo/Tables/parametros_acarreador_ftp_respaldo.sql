CREATE TABLE [dbo].[parametros_acarreador_ftp_respaldo] (
    [sucursal]         TINYINT       NOT NULL,
    [cliente]          VARCHAR (30)  NOT NULL,
    [tipo_archivo]     VARCHAR (30)  NOT NULL,
    [descripcion]      VARCHAR (50)  NULL,
    [ip_origen]        VARCHAR (30)  NULL,
    [usuario_origen]   VARCHAR (30)  NULL,
    [password_origen]  VARCHAR (30)  NULL,
    [archivo_origen]   VARCHAR (100) NULL,
    [ip_destino]       VARCHAR (30)  NULL,
    [usuario_destino]  VARCHAR (30)  NULL,
    [password_destino] VARCHAR (30)  NULL,
    [archivo_destino]  VARCHAR (100) NULL,
    [hora]             VARCHAR (20)  NULL,
    [bolsa1]           VARCHAR (5)   NULL,
    [bolsa2]           VARCHAR (5)   NULL
);


GO

