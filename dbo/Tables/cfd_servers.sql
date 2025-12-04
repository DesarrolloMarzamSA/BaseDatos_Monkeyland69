CREATE TABLE [dbo].[cfd_servers] (
    [ip_server]   VARCHAR (16) NOT NULL,
    [descripcion] VARCHAR (50) NOT NULL,
    [orden]       INT          NULL,
    [habilitado]  BIT          NULL,
    PRIMARY KEY CLUSTERED ([ip_server] ASC) WITH (FILLFACTOR = 90)
);


GO

