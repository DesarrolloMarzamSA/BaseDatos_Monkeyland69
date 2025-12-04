CREATE TABLE [dbo].[casa_ley_lotes] (
    [arch_cliente] VARCHAR (50) NOT NULL,
    [hash_md5]     VARCHAR (50) NOT NULL,
    [fecha]        DATETIME     NOT NULL,
    [finalizado]   TINYINT      NULL,
    CONSTRAINT [PK_casa_ley_lotes] PRIMARY KEY CLUSTERED ([hash_md5] ASC) WITH (FILLFACTOR = 90)
);


GO

