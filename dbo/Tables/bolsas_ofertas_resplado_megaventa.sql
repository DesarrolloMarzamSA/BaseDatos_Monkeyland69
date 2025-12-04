CREATE TABLE [dbo].[bolsas_ofertas_resplado_megaventa] (
    [cadena]     VARCHAR (20) NOT NULL,
    [sucursal]   INT          NOT NULL,
    [bolsa]      VARCHAR (5)  NOT NULL,
    [orden]      INT          NULL,
    [habilitado] BIT          NULL,
    [unidades]   INT          NULL,
    [timestamp]  DATETIME     NULL
);


GO

