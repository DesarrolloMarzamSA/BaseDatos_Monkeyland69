CREATE TABLE [dbo].[bitacora_sanborns_cfd] (
    [fecha]         DATE           NULL,
    [sucursal]      TINYINT        NOT NULL,
    [serie_cfd]     VARCHAR (5)    NOT NULL,
    [folio_fiscal]  VARCHAR (10)   NOT NULL,
    [remision]      VARCHAR (10)   NOT NULL,
    [cliente]       VARCHAR (5)    NOT NULL,
    [confirmada]    INT            NULL,
    [articulos]     INT            NULL,
    [importe]       MONEY          NULL,
    [mostrador]     INT            NULL,
    [tienda]        VARCHAR (50)   NULL,
    [confirmacion]  VARCHAR (20)   NULL,
    [intento]       INT            NULL,
    [no_error]      INT            NULL,
    [tipo_error]    VARCHAR (100)  NULL,
    [msg_error]     VARCHAR (2000) NULL,
    [pedido]        VARCHAR (10)   NULL,
    [archivo]       VARCHAR (200)  NULL,
    [identificador] VARCHAR (20)   NULL,
    [folio]         INT            IDENTITY (1, 1) NOT NULL,
    [registro]      DATETIME       NOT NULL,
    CONSTRAINT [PK__bitacora__1C350CF75A502F92] PRIMARY KEY CLUSTERED ([serie_cfd] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_suc_cte]
    ON [dbo].[bitacora_sanborns_cfd]([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_sanb_fecha]
    ON [dbo].[bitacora_sanborns_cfd]([fecha] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_sanb_registro]
    ON [dbo].[bitacora_sanborns_cfd]([registro] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_b_sanb_suc_fol]
    ON [dbo].[bitacora_sanborns_cfd]([sucursal] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90);


GO

