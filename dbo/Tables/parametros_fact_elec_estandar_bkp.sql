CREATE TABLE [dbo].[parametros_fact_elec_estandar_bkp] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [sucursal]         INT            NOT NULL,
    [cliente]          VARCHAR (25)   NOT NULL,
    [descripcion]      VARCHAR (50)   NULL,
    [envia_mail]       BIT            NULL,
    [email_addr]       VARCHAR (1000) NULL,
    [query]            VARCHAR (500)  NULL,
    [ip_cliente]       VARCHAR (15)   NULL,
    [usuario_cliente]  VARCHAR (50)   NULL,
    [password_cliente] VARCHAR (50)   NULL,
    [ruta_cliente]     VARCHAR (50)   NULL,
    [nombre_archivo]   VARCHAR (50)   NULL,
    [envia_ftp]        INT            NULL,
    [unsoloarchivo]    BIT            NULL,
    [fecha_alta]       DATE           NULL,
    [selex]            INT            NULL
);


GO

