CREATE TABLE [dbo].[cat_farmapronto] (
    [sucursal] TINYINT     NOT NULL,
    [cliente]  VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_cat_farmapronto] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

