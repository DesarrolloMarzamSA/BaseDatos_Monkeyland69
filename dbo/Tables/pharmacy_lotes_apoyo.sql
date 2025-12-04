CREATE TABLE [dbo].[pharmacy_lotes_apoyo] (
    [arch_cliente] VARCHAR (50) NOT NULL,
    [hash_md5]     VARCHAR (50) NOT NULL,
    [fecha]        DATETIME     NOT NULL,
    [finalizado]   TINYINT      NULL,
    CONSTRAINT [PK_pharmacy_lotes_apoyo] PRIMARY KEY CLUSTERED ([arch_cliente] ASC, [hash_md5] ASC) WITH (FILLFACTOR = 90)
);


GO

