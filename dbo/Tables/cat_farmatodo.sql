CREATE TABLE [dbo].[cat_farmatodo] (
    [farmacia]   VARCHAR (35) NULL,
    [cuenta]     VARCHAR (5)  NOT NULL,
    [digito]     INT          NULL,
    [sucursal]   INT          NULL,
    [tda]        INT          NOT NULL,
    [codsuc]     INT          NOT NULL,
    [autorizada] VARCHAR (1)  NULL,
    CONSTRAINT [PK_cat_farmatodo] PRIMARY KEY CLUSTERED ([cuenta] ASC, [tda] ASC, [codsuc] ASC) WITH (FILLFACTOR = 90)
);


GO

