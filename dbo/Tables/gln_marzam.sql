CREATE TABLE [dbo].[gln_marzam] (
    [sucursal]      INT           NOT NULL,
    [cliente]       VARCHAR (5)   NOT NULL,
    [farmacia]      VARCHAR (100) NULL,
    [direccion]     VARCHAR (100) NULL,
    [ciudad]        VARCHAR (100) NULL,
    [estado]        INT           NULL,
    [codigo_postal] VARCHAR (5)   NULL,
    [rfc]           VARCHAR (14)  NULL,
    [gln]           VARCHAR (14)  NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC) WITH (FILLFACTOR = 90)
);


GO

