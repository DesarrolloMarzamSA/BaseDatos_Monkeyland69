CREATE TABLE [dbo].[metodos_ofertas_ctes_estandar] (
    [cadena]     VARCHAR (20) NOT NULL,
    [sucursal]   INT          NOT NULL,
    [metodo]     CHAR (5)     NOT NULL,
    [orden]      INT          NULL,
    [habilitado] BIT          NULL,
    [unidades]   INT          NULL,
    PRIMARY KEY CLUSTERED ([cadena] ASC, [sucursal] ASC, [metodo] ASC) WITH (FILLFACTOR = 90)
);


GO

