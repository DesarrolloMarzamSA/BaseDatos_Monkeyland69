CREATE TABLE [dbo].[cat_tiendas_chedraui] (
    [cuenta_estilo_chedraui] CHAR (6)     NOT NULL,
    [farmacia]               VARCHAR (50) NULL,
    [sucursal]               TINYINT      NOT NULL,
    [cliente]                CHAR (5)     NOT NULL,
    [timestamp]              DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([cuenta_estilo_chedraui] ASC) WITH (FILLFACTOR = 90)
);


GO

