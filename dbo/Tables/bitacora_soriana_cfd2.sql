CREATE TABLE [dbo].[bitacora_soriana_cfd2] (
    [fecha]         DATE           NULL,
    [registro]      SMALLDATETIME  NULL,
    [sucursal]      INT            NOT NULL,
    [serie_cfd]     VARCHAR (2)    NOT NULL,
    [folio_fiscal]  VARCHAR (10)   NOT NULL,
    [remision]      VARCHAR (50)   NULL,
    [cliente]       VARCHAR (5)    NOT NULL,
    [articulos]     INT            NULL,
    [importe]       MONEY          NULL,
    [confirmada]    INT            CONSTRAINT [DF_bitacora_soriana_cfd_confirmada2] DEFAULT ((0)) NULL,
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
    [pagada]        BIT            DEFAULT ((0)) NULL,
    [identificador] VARCHAR (10)   NULL,
    [estatus]       VARCHAR (1)    NULL,
    [xml_data]      VARCHAR (8000) NULL,
    [xml_aperak]    VARCHAR (8000) NULL,
    [folio]         INT            NULL,
    PRIMARY KEY CLUSTERED ([serie_cfd] ASC, [folio_fiscal] ASC)
);


GO

