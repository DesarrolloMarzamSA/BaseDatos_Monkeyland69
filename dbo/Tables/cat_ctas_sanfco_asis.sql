CREATE TABLE [dbo].[cat_ctas_sanfco_asis] (
    [sucursal] INT          NOT NULL,
    [cuenta]   VARCHAR (5)  NOT NULL,
    [farmacia] VARCHAR (50) NULL,
    [no_tda]   INT          NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC) WITH (FILLFACTOR = 90)
);


GO

