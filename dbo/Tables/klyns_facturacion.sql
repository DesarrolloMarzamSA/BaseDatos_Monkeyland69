CREATE TABLE [dbo].[klyns_facturacion] (
    [sucursal]        TINYINT      NULL,
    [cliente]         VARCHAR (5)  NOT NULL,
    [arch_tandem]     VARCHAR (8)  NULL,
    [orden]           VARCHAR (50) NOT NULL,
    [esucursal]       CHAR (10)    NULL,
    [codigo_farmacia] VARCHAR (20) NULL,
    [eordencompra]    VARCHAR (20) NULL,
    [xtimestamp]      DATETIME     NULL
);


GO

