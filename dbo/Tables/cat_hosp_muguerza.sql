CREATE TABLE [dbo].[cat_hosp_muguerza] (
    [cliente_ibs] VARCHAR (6)  NOT NULL,
    [unidad]      INT          NOT NULL,
    [sucursal]    INT          NULL,
    [cliente]     VARCHAR (5)  NULL,
    [alta]        DATE         NULL,
    [banco]       VARCHAR (20) NULL,
    [cta]         VARCHAR (20) NOT NULL,
    [origen]      VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([cliente_ibs] ASC, [unidad] ASC, [cta] ASC) WITH (FILLFACTOR = 90)
);


GO

