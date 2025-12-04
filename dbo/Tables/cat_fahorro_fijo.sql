CREATE TABLE [dbo].[cat_fahorro_fijo] (
    [codigo]     VARCHAR (7)  NOT NULL,
    [cod_barras] VARCHAR (13) NOT NULL,
    CONSTRAINT [PK_cat_fahorro_fijo] PRIMARY KEY CLUSTERED ([codigo] ASC, [cod_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

