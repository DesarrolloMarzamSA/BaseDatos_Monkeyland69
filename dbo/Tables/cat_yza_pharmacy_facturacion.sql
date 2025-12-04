CREATE TABLE [dbo].[cat_yza_pharmacy_facturacion] (
    [sucursal]  TINYINT      NOT NULL,
    [cliente]   VARCHAR (5)  NOT NULL,
    [mostrador] VARCHAR (10) NULL,
    CONSTRAINT [PK_cat_yza_pharmacy_facturacion] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

