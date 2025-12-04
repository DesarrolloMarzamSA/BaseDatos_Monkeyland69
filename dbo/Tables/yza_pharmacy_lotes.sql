CREATE TABLE [dbo].[yza_pharmacy_lotes] (
    [arch_cliente] VARCHAR (50) NOT NULL,
    [hash_md5]     VARCHAR (50) NOT NULL,
    [fecha]        DATETIME     NOT NULL,
    [finalizado]   TINYINT      NULL,
    CONSTRAINT [PK_yza_pharmacy_lotes] PRIMARY KEY CLUSTERED ([arch_cliente] ASC, [hash_md5] ASC) WITH (FILLFACTOR = 90)
);


GO

