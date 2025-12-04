CREATE TABLE [dbo].[pedidos_carer_registros_basura] (
    [hash_md5] VARCHAR (50) NOT NULL,
    [basura]   VARCHAR (25) NOT NULL,
    [fecha]    DATETIME     NOT NULL,
    CONSTRAINT [PK_pedidos_carer_registros_basura] PRIMARY KEY CLUSTERED ([hash_md5] ASC, [basura] ASC, [fecha] ASC)
);


GO

