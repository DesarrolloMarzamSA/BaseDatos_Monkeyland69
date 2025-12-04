CREATE TABLE [dbo].[clientes_ofertas] (
    [sucursal]      TINYINT     NOT NULL,
    [cliente]       VARCHAR (5) NOT NULL,
    [bandera_libre] VARCHAR (1) NULL,
    [bandera_plus]  VARCHAR (2) NULL,
    [bandera_mega]  VARCHAR (2) NULL,
    [timestamp]     DATETIME    DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_clientes_ofertas_bandera_mega]
    ON [dbo].[clientes_ofertas]([bandera_mega] ASC) WITH (FILLFACTOR = 90);


GO

