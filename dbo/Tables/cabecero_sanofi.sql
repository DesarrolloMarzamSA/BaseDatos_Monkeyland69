CREATE TABLE [dbo].[cabecero_sanofi] (
    [md5]                     VARCHAR (50)  NOT NULL,
    [b2b_order_number]        VARCHAR (60)  NULL,
    [ws_code]                 VARCHAR (90)  NULL,
    [ws_customer_code]        VARCHAR (90)  NULL,
    [delivery_date]           DATETIME      NULL,
    [memo]                    VARCHAR (240) NULL,
    [sa_order_total_discount] FLOAT (53)    NULL,
    [total_amount]            FLOAT (53)    NULL,
    [order_date]              DATETIME      NULL,
    [payment_type]            VARCHAR (100) NULL,
    [user_name]               VARCHAR (90)  NULL,
    [first_name]              VARCHAR (90)  NULL,
    [last_name]               VARCHAR (90)  NULL,
    CONSTRAINT [PK_cabecero_sanofi_1] PRIMARY KEY CLUSTERED ([md5] ASC) WITH (FILLFACTOR = 90)
);


GO

