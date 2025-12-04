CREATE TABLE [dbo].[cat_farmacon] (
    [sucursal]  TINYINT  NOT NULL,
    [cuenta]    CHAR (5) NOT NULL,
    [timestamp] DATETIME NULL,
    CONSTRAINT [PK_cat_farmacon] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC) WITH (FILLFACTOR = 90)
);


GO

