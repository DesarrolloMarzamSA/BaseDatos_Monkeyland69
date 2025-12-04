CREATE TABLE [dbo].[cat_premier] (
    [sucursal] TINYINT     NOT NULL,
    [cliente]  VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_cat_premier] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

