CREATE TABLE [dbo].[pedidoHEB_Detalle] (
    [item]                    INT             NULL,
    [product_id]              INT             NOT NULL,
    [department_article_id]   INT             NULL,
    [department_article_desc] VARCHAR (150)   NULL,
    [bar_code]                VARCHAR (150)   NOT NULL,
    [article_desc]            VARCHAR (150)   NULL,
    [measurement_unit]        VARCHAR (150)   NULL,
    [ordered_quantity]        INT             NOT NULL,
    [packing_factor]          NUMERIC (18, 4) NULL,
    [packaging_quantity]      INT             NULL,
    [unit_price]              MONEY           NULL,
    [FechaRegistro]           DATETIME        NULL,
    [Purchase_order]          NUMERIC (18, 4) NOT NULL,
    [Subsidiary_gln]          VARCHAR (150)   NOT NULL,
    [Subsidiary]              INT             NOT NULL,
    [estatus]                 INT             NULL,
    [archivoMarzam]           VARCHAR (90)    NULL,
    CONSTRAINT [PK_pedidoHEB_Detalle] PRIMARY KEY CLUSTERED ([product_id] ASC, [bar_code] ASC, [ordered_quantity] ASC, [Purchase_order] ASC, [Subsidiary_gln] ASC, [Subsidiary] ASC) WITH (FILLFACTOR = 90)
);


GO

