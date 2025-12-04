CREATE TABLE [dbo].[catalogo_chedraui_tiendas_V3] (
    [cliente_ibs] VARCHAR (7)  NOT NULL,
    [sucursal]    INT          NULL,
    [cliente]     VARCHAR (7)  NULL,
    [tienda]      INT          NULL,
    [zona]        INT          NULL,
    [gln]         VARCHAR (13) NULL,
    PRIMARY KEY CLUSTERED ([cliente_ibs] ASC) WITH (FILLFACTOR = 90)
);


GO

