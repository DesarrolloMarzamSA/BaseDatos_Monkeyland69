CREATE TABLE [dbo].[direcciones_sanofi] (
    [md5]              VARCHAR (50)  NOT NULL,
    [tipo]             INT           NOT NULL,
    [b2b_order_number] VARCHAR (60)  NOT NULL,
    [FirstName]        VARCHAR (100) NULL,
    [LastName]         VARCHAR (100) NULL,
    [Address1]         VARCHAR (100) NULL,
    [Address2]         VARCHAR (100) NULL,
    [Address3]         VARCHAR (100) NULL,
    [City]             VARCHAR (50)  NULL,
    [PostalCode]       VARCHAR (20)  NULL,
    [State]            VARCHAR (20)  NULL,
    [Country]          VARCHAR (20)  NULL,
    [CompanyName]      VARCHAR (100) NULL,
    CONSTRAINT [PK_direcciones_sanofi] PRIMARY KEY CLUSTERED ([md5] ASC, [tipo] ASC) WITH (FILLFACTOR = 90)
);


GO

