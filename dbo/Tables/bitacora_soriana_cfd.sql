CREATE TABLE [dbo].[bitacora_soriana_cfd] (
    [fecha]         DATE           NULL,
    [registro]      SMALLDATETIME  NULL,
    [sucursal]      INT            NOT NULL,
    [serie_cfd]     VARCHAR (2)    NOT NULL,
    [folio_fiscal]  VARCHAR (10)   NOT NULL,
    [remision]      VARCHAR (10)   NOT NULL,
    [cliente]       VARCHAR (5)    NOT NULL,
    [articulos]     INT            NULL,
    [importe]       MONEY          NULL,
    [confirmada]    INT            CONSTRAINT [DF_bitacora_soriana_cfd_confirmada] DEFAULT ((0)) NULL,
    [confirmacion]  INT            NULL,
    [mostrador]     VARCHAR (50)   NULL,
    [tienda]        INT            NULL,
    [intento]       INT            NULL,
    [no_error]      INT            NULL,
    [tipo_error]    VARCHAR (100)  NULL,
    [msg_error]     VARCHAR (2000) NULL,
    [pedido]        VARCHAR (10)   NULL,
    [archivo]       VARCHAR (50)   NULL,
    [no_aprobacion] INT            NULL,
    [folio_entrada] INT            NULL,
    [pagada]        BIT            DEFAULT (0) NULL,
    [identificador] VARCHAR (10)   NULL,
    [estatus]       VARCHAR (1)    NULL,
    [xml_data]      VARCHAR (8000) NULL,
    [xml_aperak]    VARCHAR (8000) NULL,
    [folio]         INT            NULL,
    PRIMARY KEY CLUSTERED ([serie_cfd] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_bit_soriana_id]
    ON [dbo].[bitacora_soriana_cfd]([identificador] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [idx_bit_sori_fecha]
    ON [dbo].[bitacora_soriana_cfd]([fecha] ASC) WITH (FILLFACTOR = 90);


GO

