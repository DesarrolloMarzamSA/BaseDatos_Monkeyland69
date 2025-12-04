CREATE TABLE [dbo].[pedidos_carer_registros_basura_historia] (
    [hash_md5]       VARCHAR (50) NOT NULL,
    [basura]         VARCHAR (25) NOT NULL,
    [fecha]          DATETIME     NOT NULL,
    [fecha_historia] DATETIME     NOT NULL,
    CONSTRAINT [PK_pedidos_carer_registros_basura_historia] PRIMARY KEY CLUSTERED ([hash_md5] ASC, [basura] ASC, [fecha] ASC, [fecha_historia] ASC)
);


GO

