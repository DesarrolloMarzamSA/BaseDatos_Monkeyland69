CREATE TABLE [dbo].[cat_farmatodo_cofar_facturacion] (
    [sucursal]        INT         NOT NULL,
    [cliente]         VARCHAR (5) NOT NULL,
    [codigo_farmacia] INT         NOT NULL,
    CONSTRAINT [PK_cat_farmatodo_cofar_facturacion] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

