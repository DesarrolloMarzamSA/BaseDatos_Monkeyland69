CREATE TABLE [dbo].[pedidoHEB_Detalle2] (
    [item]                    INT             NULL,
    [product_id]              INT             NULL,
    [department_article_id]   INT             NULL,
    [department_article_desc] VARCHAR (150)   NULL,
    [bar_code]                VARCHAR (150)   NULL,
    [article_desc]            VARCHAR (150)   NULL,
    [measurement_unit]        VARCHAR (150)   NULL,
    [ordered_quantity]        INT             NULL,
    [packing_factor]          NUMERIC (18, 4) NULL,
    [packaging_quantity]      INT             NULL,
    [unit_price]              MONEY           NULL,
    [FechaRegistro]           DATETIME        NULL,
    [Purchase_order]          NUMERIC (18, 4) NULL,
    [Subsidiary_gln]          VARCHAR (150)   NULL,
    [Subsidiary]              INT             NULL,
    [estatus]                 INT             NULL,
    [archivoMarzam]           VARCHAR (90)    NULL
);


GO

