CREATE TABLE [dbo].[complementoSATFahorro] (
    [cliente]              VARCHAR (12) NOT NULL,
    [clientePadre]         VARCHAR (5)  NOT NULL,
    [ingreso]              VARCHAR (5)  NULL,
    [formaPago]            VARCHAR (10) NULL,
    [regimenConsolidacion] VARCHAR (10) NULL,
    [metodoPago]           VARCHAR (10) NULL,
    [usoCFDI]              VARCHAR (10) NULL,
    [fechaActualizacion]   DATETIME     CONSTRAINT [DF_complementoSATFahorro_fechaActualizacion] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_complementoSATFahorro] PRIMARY KEY CLUSTERED ([cliente] ASC, [clientePadre] ASC)
);


GO

