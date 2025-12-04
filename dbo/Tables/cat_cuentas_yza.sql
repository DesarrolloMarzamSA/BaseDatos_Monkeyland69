CREATE TABLE [dbo].[cat_cuentas_yza] (
    [sucursal]          TINYINT  NOT NULL,
    [cliente]           CHAR (5) NOT NULL,
    [cuenta_estilo_yza] CHAR (7) NOT NULL,
    [timestamp]         DATETIME NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC, [cuenta_estilo_yza] ASC) WITH (FILLFACTOR = 90)
);


GO

