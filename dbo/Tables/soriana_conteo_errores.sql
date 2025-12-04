CREATE TABLE [dbo].[soriana_conteo_errores] (
    [msg_error] VARCHAR (500) NOT NULL,
    [facturas]  INT           NULL,
    [importe]   MONEY         NULL,
    [orden]     INT           IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([msg_error] ASC) WITH (FILLFACTOR = 90)
);


GO

