CREATE TABLE [dbo].[cat_tiendas_walmart] (
    [id_catalogo] INT           IDENTITY (1, 1) NOT NULL,
    [admxglnc]    VARCHAR (50)  NOT NULL,
    [nanum]       VARCHAR (15)  NOT NULL,
    [naname]      VARCHAR (350) NOT NULL,
    [nanca1]      VARCHAR (50)  NULL,
    CONSTRAINT [PK_cat_tiendas_walmart] PRIMARY KEY CLUSTERED ([id_catalogo] ASC) WITH (FILLFACTOR = 90)
);


GO

