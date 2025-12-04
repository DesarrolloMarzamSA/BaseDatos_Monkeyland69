CREATE TABLE [dbo].[cat_rivera_facturacion] (
    [sucursal]    TINYINT     NOT NULL,
    [cliente]     VARCHAR (5) NOT NULL,
    [abreviacion] CHAR (5)    NULL,
    CONSTRAINT [PK_cat_rivera_facturacion] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

