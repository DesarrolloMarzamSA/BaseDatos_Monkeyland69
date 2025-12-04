CREATE TABLE [dbo].[fanasa_catalogo_manual] (
    [codigo]          VARCHAR (20) NOT NULL,
    [codigo_barras]   VARCHAR (20) NOT NULL,
    [desc_oferta]     FLOAT (53)   NOT NULL,
    [desc_financiero] FLOAT (53)   NOT NULL,
    PRIMARY KEY CLUSTERED ([codigo] ASC, [codigo_barras] ASC)
);


GO

