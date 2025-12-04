CREATE TABLE [dbo].[cat_clubes_costco] (
    [sucursal]    INT          NOT NULL,
    [cliente]     VARCHAR (5)  NOT NULL,
    [tienda]      VARCHAR (5)  NOT NULL,
    [descripcion] VARCHAR (40) NULL,
    CONSTRAINT [PK_cat_clubes_costco] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [tienda] ASC) WITH (FILLFACTOR = 90)
);


GO

