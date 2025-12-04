CREATE TABLE [dbo].[cat_ctas_fregis] (
    [sucursal]  TINYINT       NOT NULL,
    [cliente]   CHAR (5)      NOT NULL,
    [farmacia]  VARCHAR (50)  NOT NULL,
    [domingos]  VARCHAR (5)   NULL,
    [mostrador] INT           NULL,
    [timestamp] SMALLDATETIME NULL,
    [activa]    BIT           NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

