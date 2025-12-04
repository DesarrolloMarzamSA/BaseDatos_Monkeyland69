CREATE TABLE [dbo].[cat_fahorro_franquicias] (
    [sucursal]  INT         NOT NULL,
    [cliente]   VARCHAR (5) NOT NULL,
    [timestamp] DATETIME    NULL,
    CONSTRAINT [PK_cat_fahorro_franquicias] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

