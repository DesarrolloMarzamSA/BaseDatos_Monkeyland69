CREATE TABLE [dbo].[proveedoresftppagos] (
    [id_proveeftp]    NVARCHAR (200) NOT NULL,
    [nombre]          NVARCHAR (200) NULL,
    [carpeta]         NVARCHAR (50)  NULL,
    [id_ftp_fk]       INT            NULL,
    [usuarioregistra] VARCHAR (60)   NULL,
    CONSTRAINT [FK_proveedoresftppagos_ftpprovedorespagos] FOREIGN KEY ([id_ftp_fk]) REFERENCES [dbo].[ftpprovedorespagos] ([id_ftp])
);


GO

