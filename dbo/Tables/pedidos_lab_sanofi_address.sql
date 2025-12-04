CREATE TABLE [dbo].[pedidos_lab_sanofi_address] (
    [b2b_order_number] VARCHAR (60) NOT NULL,
    [seccion]          VARCHAR (30) NOT NULL,
    [sucursal]         INT          NULL,
    [letra]            CHAR (1)     NULL,
    [cliente]          VARCHAR (6)  NULL,
    [CompanyName]      VARCHAR (90) NULL,
    [FirstName]        VARCHAR (90) NULL,
    [LastName]         VARCHAR (90) NULL,
    [Address1]         VARCHAR (90) NULL,
    [Address2]         VARCHAR (90) NULL,
    [Address3]         VARCHAR (90) NULL,
    [City]             VARCHAR (90) NULL,
    [PostalCode]       VARCHAR (90) NULL,
    [State]            VARCHAR (90) NULL,
    [Country]          VARCHAR (90) NULL,
    [recepcion]        DATETIME     NULL,
    [procesado]        BIT          DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([b2b_order_number] ASC, [seccion] ASC) WITH (FILLFACTOR = 90)
);


GO

