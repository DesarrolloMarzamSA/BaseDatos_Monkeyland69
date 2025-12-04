CREATE TABLE [dbo].[cat_ean_prg] (
    [codigo]        VARCHAR (35)  NOT NULL,
    [codigo_barras] VARCHAR (35)  NOT NULL,
    [descripcion]   VARCHAR (100) NOT NULL,
    [estatus]       VARCHAR (1)   NOT NULL,
    CONSTRAINT [PK__cat_ean___F7C9586D06AEA014] PRIMARY KEY CLUSTERED ([codigo] ASC, [codigo_barras] ASC) WITH (FILLFACTOR = 90)
);


GO

