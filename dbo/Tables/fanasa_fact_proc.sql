CREATE TABLE [dbo].[fanasa_fact_proc] (
    [archivo_embarque] VARCHAR (20) NOT NULL,
    [fecha_creacion]   DATETIME     NOT NULL,
    [factura_ibs]      VARCHAR (20) NULL,
    [factura]          VARCHAR (20) NOT NULL,
    [cuenta]           VARCHAR (20) NOT NULL,
    [fecha]            DATETIME     NOT NULL,
    [codigo_barras]    VARCHAR (20) NOT NULL,
    [prec_farmacia]    VARCHAR (20) NOT NULL,
    [cantidad_surtida] VARCHAR (20) NOT NULL,
    [constante]        VARCHAR (20) NOT NULL,
    [iva]              VARCHAR (20) NOT NULL,
    [oferta]           VARCHAR (20) NOT NULL,
    [descuento]        VARCHAR (20) NOT NULL,
    [referencia]       VARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([archivo_embarque] ASC, [fecha_creacion] ASC, [factura] ASC, [cuenta] ASC, [fecha] ASC, [codigo_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

