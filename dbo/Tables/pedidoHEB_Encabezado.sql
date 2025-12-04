CREATE TABLE [dbo].[pedidoHEB_Encabezado] (
    [Document_type]          VARCHAR (150)   NULL,
    [Heb_rfc]                VARCHAR (150)   NULL,
    [Vendor_number]          INT             NULL,
    [Vendor_rfc]             VARCHAR (150)   NULL,
    [Detail_number_of_lines] INT             NOT NULL,
    [Purchase_order]         NUMERIC (18, 4) NOT NULL,
    [Subsidiary_gln]         VARCHAR (150)   NOT NULL,
    [Subsidiary]             INT             NOT NULL,
    [Subsidiary_desc]        VARCHAR (150)   NULL,
    [Subsidiary_address]     VARCHAR (150)   NULL,
    [Subsidiary_city]        VARCHAR (150)   NULL,
    [Cancellation_date]      DATETIME        NULL,
    [Department_id]          INT             NOT NULL,
    [Department]             VARCHAR (150)   NULL,
    [Vendor]                 VARCHAR (150)   NULL,
    [Purchase_date]          DATETIME        NULL,
    [Operation_date]         DATETIME        NULL,
    [Estatus]                VARCHAR (150)   NOT NULL,
    [Receipt_date]           DATETIME        NULL,
    [Comments]               VARCHAR (150)   NULL,
    [Buyer_id]               INT             NOT NULL,
    [Buyer]                  VARCHAR (150)   NULL,
    [Total_pretax]           NUMERIC (18, 4) NULL,
    [Total_packs]            INT             NULL,
    [FechaRegistro]          DATETIME        NULL,
    [EstatusEnvio]           INT             NULL,
    [idPedido]               INT             IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_pedidoHEB_Encabezado] PRIMARY KEY CLUSTERED ([Detail_number_of_lines] ASC, [Purchase_order] ASC, [Subsidiary_gln] ASC, [Subsidiary] ASC, [Department_id] ASC, [Estatus] ASC, [Buyer_id] ASC, [idPedido] ASC) WITH (FILLFACTOR = 90)
);


GO

