CREATE TABLE [dbo].[cat_cuentas_funion] (
    [sucursal]   TINYINT       NOT NULL,
    [cliente]    VARCHAR (5)   NOT NULL,
    [nombre]     VARCHAR (100) NULL,
    [tienda]     INT           NULL,
    [fecha_alta] SMALLDATETIME NULL,
    [ticket]     INT           NULL,
    [cuenta_ibs] CHAR (6)      NULL,
    [frontera]   BIT           DEFAULT ((0)) NULL,
    [cadena]     VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

