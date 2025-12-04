CREATE TABLE [dbo].[pedidos_chedraui] (
    [zona]                   CHAR (1)      NOT NULL,
    [cuenta_estilo_chedraui] CHAR (6)      NOT NULL,
    [orden]                  VARCHAR (10)  NULL,
    [cod_barras]             VARCHAR (13)  NOT NULL,
    [cant_ped]               INT           NULL,
    [cant_surt]              INT           NULL,
    [cant_oferta]            INT           NULL,
    [prec_farm]              MONEY         NULL,
    [porcentaje_oferta]      MONEY         NULL,
    [porcentaje_descuento]   MONEY         NULL,
    [sucursal]               TINYINT       NULL,
    [cliente]                CHAR (5)      NULL,
    [codigo]                 VARCHAR (7)   NULL,
    [arch_tandem]            VARCHAR (8)   NULL,
    [fecha_pedido]           SMALLDATETIME NULL,
    [fecha_respuesta]        SMALLDATETIME NULL,
    [timestamp]              SMALLDATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([zona] ASC, [cuenta_estilo_chedraui] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

