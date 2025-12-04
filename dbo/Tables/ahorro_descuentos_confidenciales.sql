CREATE TABLE [dbo].[ahorro_descuentos_confidenciales] (
    [codigo_marzam]             VARCHAR (10) NOT NULL,
    [codigo_ean]                VARCHAR (15) NOT NULL,
    [descuento_facturado]       FLOAT (53)   NOT NULL,
    [descuento_volumen]         FLOAT (53)   CONSTRAINT [DF_ahorro_descuentos_confidenciales_descuento_volumen] DEFAULT ((0)) NOT NULL,
    [desceunto_pronto_pago]     FLOAT (53)   CONSTRAINT [DF_ahorro_descuentos_confidenciales_desceunto_pronto_pago] DEFAULT ((0)) NOT NULL,
    [descuento_adicional]       FLOAT (53)   CONSTRAINT [DF_ahorro_descuentos_confidenciales_descuento_adicional] DEFAULT ((0)) NOT NULL,
    [descuento_total_ponderado] FLOAT (53)   NOT NULL,
    CONSTRAINT [PK_ahorro_descuentos_confidenciales] PRIMARY KEY CLUSTERED ([codigo_marzam] ASC) WITH (FILLFACTOR = 90)
);


GO

