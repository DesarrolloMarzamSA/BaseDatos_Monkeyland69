CREATE TABLE [dbo].[cat_esquivar] (
    [sucursal] TINYINT     NOT NULL,
    [cliente]  VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_cat_esquivar] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

