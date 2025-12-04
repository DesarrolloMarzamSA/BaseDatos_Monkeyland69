CREATE TABLE [dbo].[cat_carer] (
    [sucursal] TINYINT     NOT NULL,
    [cliente]  VARCHAR (5) NOT NULL,
    CONSTRAINT [PK_cat_carer] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

