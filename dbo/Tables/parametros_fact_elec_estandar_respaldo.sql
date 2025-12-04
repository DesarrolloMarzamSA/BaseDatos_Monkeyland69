CREATE TABLE [dbo].[parametros_fact_elec_estandar_respaldo] (
    [sucursal]         INT            NOT NULL,
    [cliente]          VARCHAR (25)   NOT NULL,
    [envia_mail]       INT            NULL,
    [email_addr]       VARCHAR (1000) NULL,
    [query]            VARCHAR (500)  NULL,
    [ip_cliente]       VARCHAR (15)   NULL,
    [usuario_cliente]  VARCHAR (50)   NULL,
    [password_cliente] VARCHAR (50)   NULL,
    [ruta_cliente]     VARCHAR (50)   NULL,
    [nombre_archivo]   VARCHAR (50)   NULL,
    [envia_ftp]        INT            NULL,
    [unsoloarchivo]    INT            NULL,
    [selex]            INT            NULL
);


GO

