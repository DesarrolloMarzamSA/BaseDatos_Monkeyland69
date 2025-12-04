CREATE TABLE [dbo].[bolsas_ofertas] (
    [cadena]     VARCHAR (20) NOT NULL,
    [sucursal]   INT          NOT NULL,
    [bolsa]      VARCHAR (5)  NOT NULL,
    [orden]      INT          NULL,
    [habilitado] BIT          NULL,
    [unidades]   INT          NULL,
    [timestamp]  DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([cadena] ASC, [sucursal] ASC, [bolsa] ASC) WITH (FILLFACTOR = 90)
);


GO

