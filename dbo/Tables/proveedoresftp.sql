CREATE TABLE [dbo].[proveedoresftp] (
    [id_proveeftp] NVARCHAR (200) NOT NULL,
    [nombre]       NVARCHAR (200) NULL,
    [id_ftp_fk]    INT            NULL,
    [carpeta]      NVARCHAR (50)  NULL,
    [usuarioreg]   VARCHAR (10)   NULL,
    PRIMARY KEY CLUSTERED ([id_proveeftp] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [id_ftp_fk] FOREIGN KEY ([id_ftp_fk]) REFERENCES [dbo].[ftpprovedores] ([id_ftp])
);


GO

