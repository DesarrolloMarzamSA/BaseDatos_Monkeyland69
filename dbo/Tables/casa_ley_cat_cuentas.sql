CREATE TABLE [dbo].[casa_ley_cat_cuentas] (
    [sucursal]        TINYINT     NOT NULL,
    [cliente]         CHAR (5)    NOT NULL,
    [codigo_farmacia] VARCHAR (4) NULL,
    [timestamp]       DATETIME    NULL,
    CONSTRAINT [PK_casa_ley_cat_cuentas] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

