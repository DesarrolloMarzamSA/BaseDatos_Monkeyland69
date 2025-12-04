CREATE TABLE [dbo].[ftpprovedorespagos] (
    [id_ftp]    INT              IDENTITY (1, 1) NOT NULL,
    [servidor]  NVARCHAR (30)    NULL,
    [usuario]   NVARCHAR (30)    NULL,
    [passwordd] VARBINARY (8000) NULL,
    [carpeta]   NVARCHAR (100)   NULL,
    [puerto]    NVARCHAR (10)    NULL,
    [tipo]      NVARCHAR (50)    NULL,
    [nombre]    NVARCHAR (50)    NULL,
    CONSTRAINT [PK_ftpprovedorespagos] PRIMARY KEY CLUSTERED ([id_ftp] ASC) WITH (FILLFACTOR = 90)
);


GO

