CREATE TABLE [dbo].[cfd_serversXml] (
    [id]        INT          IDENTITY (1, 1) NOT NULL,
    [ip_server] VARCHAR (16) NOT NULL,
    [orden]     INT          NULL,
    [tipo]      INT          NULL,
    [estatus]   INT          NULL,
    PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 90)
);


GO

