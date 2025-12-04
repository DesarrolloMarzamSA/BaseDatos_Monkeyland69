CREATE TABLE [dbo].[parametros_fact_elec_estandar] (
    [sucursal]         INT            NOT NULL,
    [cliente]          VARCHAR (25)   NOT NULL,
    [envia_mail]       INT            DEFAULT ((0)) NULL,
    [email_addr]       VARCHAR (1000) NULL,
    [query]            VARCHAR (500)  NULL,
    [ip_cliente]       VARCHAR (MAX)  NULL,
    [usuario_cliente]  VARCHAR (50)   NULL,
    [password_cliente] VARCHAR (50)   NULL,
    [ruta_cliente]     VARCHAR (50)   NULL,
    [nombre_archivo]   VARCHAR (50)   NULL,
    [envia_ftp]        INT            NULL,
    [unsoloarchivo]    INT            DEFAULT ((0)) NULL,
    [fecha_alta]       DATE           DEFAULT (getdate()) NULL,
    [selex]            INT            NULL,
    CONSTRAINT [PK__parametros_fact___3183EF80] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

