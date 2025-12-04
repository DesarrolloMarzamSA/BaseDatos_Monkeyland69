CREATE TABLE [dbo].[pharmacy_lotes_vida] (
    [arch_cliente] VARCHAR (50) NOT NULL,
    [hash_md5]     VARCHAR (50) NOT NULL,
    [fecha]        DATETIME     NOT NULL,
    [finalizado]   TINYINT      NULL,
    CONSTRAINT [PK_pharmacy_lotes_vida] PRIMARY KEY CLUSTERED ([arch_cliente] ASC, [hash_md5] ASC)
);


GO

