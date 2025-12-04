CREATE TABLE [dbo].[cat_cuentas_minne] (
    [cliente_ibs] VARCHAR (6)  NULL,
    [frontera]    BIT          NULL,
    [sucursal]    INT          NOT NULL,
    [letra]       VARCHAR (1)  NULL,
    [cliente]     VARCHAR (5)  NOT NULL,
    [farmacia]    VARCHAR (50) NULL,
    [mostrador]   INT          NULL,
    [cliente_psi] VARCHAR (6)  NULL,
    [alta]        DATE         NULL,
    [habilitado]  BIT          NULL,
    [controlados] BIT          NULL,
    [activo]      BIT          NULL,
    CONSTRAINT [PK__cat_cuen__426D021D3B2C89F4] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

