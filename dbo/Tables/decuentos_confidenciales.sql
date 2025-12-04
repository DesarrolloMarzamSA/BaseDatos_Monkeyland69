CREATE TABLE [dbo].[decuentos_confidenciales] (
    [idDescuento]   INT          IDENTITY (1, 1) NOT NULL,
    [codigo]        VARCHAR (50) NULL,
    [descuento]     MONEY        NULL,
    [cliente]       VARCHAR (50) NULL,
    [cltePadre]     VARCHAR (50) NULL,
    [sucursal]      INT          NULL,
    [fechaRegistro] DATETIME     NULL,
    CONSTRAINT [PK_product_Desto_Confidencial] PRIMARY KEY CLUSTERED ([idDescuento] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20140610-095646]
    ON [dbo].[decuentos_confidenciales]([idDescuento] ASC, [codigo] ASC, [descuento] ASC, [cliente] ASC) WITH (FILLFACTOR = 90);


GO

