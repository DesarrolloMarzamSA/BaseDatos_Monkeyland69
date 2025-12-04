CREATE TABLE [dbo].[parametros_generador_catalogos_universal] (
    [sucursal]         INT           NOT NULL,
    [cliente]          VARCHAR (50)  NOT NULL,
    [tipo_archivo]     VARCHAR (50)  NOT NULL,
    [query]            VARCHAR (250) NULL,
    [nombre_archivo]   VARCHAR (50)  NULL,
    [ip_cliente]       VARCHAR (50)  NULL,
    [usuario_cliente]  VARCHAR (50)  NULL,
    [password_cliente] VARCHAR (50)  NULL,
    [ruta_cliente]     VARCHAR (250) NULL,
    [envia_ftp]        INT           NULL,
    [emails]           VARCHAR (500) NULL,
    [envia_mail]       INT           NULL,
    [selex]            INT           NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [tipo_archivo] ASC) WITH (FILLFACTOR = 90)
);


GO

