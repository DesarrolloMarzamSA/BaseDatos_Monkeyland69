CREATE TABLE [dbo].[usps_labs_automation] (
    [interfase]    VARCHAR (50)  NOT NULL,
    [id]           VARCHAR (20)  NOT NULL,
    [usp]          VARCHAR (100) NOT NULL,
    [descripcion]  VARCHAR (200) NOT NULL,
    [orden]        INT           NOT NULL,
    [archivo]      VARCHAR (100) NOT NULL,
    [destino]      VARCHAR (100) NULL,
    [fecha_alta]   SMALLDATETIME NULL,
    [registros]    INT           NULL,
    [fecha_hora]   SMALLDATETIME NULL,
    [habilitada]   INT           NULL,
    [periodicidad] VARCHAR (20)  NULL,
    [tipo]         CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([interfase] ASC, [id] ASC)
);


GO

