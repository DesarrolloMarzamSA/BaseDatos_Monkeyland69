CREATE TABLE [dbo].[requerimientos_sistemas] (
    [idrequerimiento] INT            NOT NULL,
    [solicitante]     VARCHAR (50)   NULL,
    [solic_email]     VARCHAR (50)   NULL,
    [atiende]         VARCHAR (50)   NULL,
    [atiende_email]   VARCHAR (50)   NULL,
    [descripcion]     VARCHAR (2000) NULL,
    [creacion]        DATETIME       NULL,
    [compromiso]      DATETIME       NULL,
    [comentarios]     VARCHAR (2000) NULL,
    [ip_address]      VARCHAR (15)   NULL,
    [selex]           INT            NULL,
    CONSTRAINT [PK__requerimientos_s__123EB7A3] PRIMARY KEY CLUSTERED ([idrequerimiento] ASC) WITH (FILLFACTOR = 90)
);


GO

