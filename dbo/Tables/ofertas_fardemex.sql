CREATE TABLE [dbo].[ofertas_fardemex] (
    [sucursal]         INT         NOT NULL,
    [bolsa]            VARCHAR (5) NOT NULL,
    [codigo]           VARCHAR (7) NOT NULL,
    [cant_base]        MONEY       NULL,
    [cant_oferta]      MONEY       NULL,
    [porcentaje]       MONEY       NULL,
    [vigencia_inicial] DATE        NULL,
    [vigencia_final]   DATE        NULL,
    [disponible]       INT         NULL,
    [timestamp]        DATETIME    NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [bolsa] ASC, [codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

