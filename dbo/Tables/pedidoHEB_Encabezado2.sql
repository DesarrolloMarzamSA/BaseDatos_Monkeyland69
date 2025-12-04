CREATE TABLE [dbo].[pedidoHEB_Encabezado2] (
    [Document_type]          VARCHAR (150)   NULL,
    [Heb_rfc]                VARCHAR (150)   NULL,
    [Vendor_number]          INT             NULL,
    [Vendor_rfc]             VARCHAR (150)   NULL,
    [Detail_number_of_lines] INT             NULL,
    [Purchase_order]         NUMERIC (18, 4) NULL,
    [Subsidiary_gln]         VARCHAR (150)   NULL,
    [Subsidiary]             INT             NULL,
    [Subsidiary_desc]        VARCHAR (150)   NULL,
    [Subsidiary_address]     VARCHAR (150)   NULL,
    [Subsidiary_city]        VARCHAR (150)   NULL,
    [Cancellation_date]      DATETIME        NULL,
    [Department_id]          INT             NULL,
    [Department]             VARCHAR (150)   NULL,
    [Vendor]                 VARCHAR (150)   NULL,
    [Purchase_date]          DATETIME        NULL,
    [Operation_date]         DATETIME        NULL,
    [Estatus]                VARCHAR (150)   NULL,
    [Receipt_date]           DATETIME        NULL,
    [Comments]               VARCHAR (150)   NULL,
    [Buyer_id]               INT             NULL,
    [Buyer]                  VARCHAR (150)   NULL,
    [Total_pretax]           NUMERIC (18, 4) NULL,
    [Total_packs]            INT             NULL,
    [FechaRegistro]          DATETIME        NULL,
    [EstatusEnvio]           INT             NULL
);


GO

