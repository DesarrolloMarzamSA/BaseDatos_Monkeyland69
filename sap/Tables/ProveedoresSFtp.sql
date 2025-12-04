CREATE TABLE [sap].[ProveedoresSFtp] (
    [id_proveesftp] NVARCHAR (200) NOT NULL,
    [nombre]        NVARCHAR (200) NULL,
    [id_sftp_fk]    INT            NULL,
    [carpeta]       NVARCHAR (50)  NULL,
    [usuarioreg]    VARCHAR (10)   NULL,
    PRIMARY KEY CLUSTERED ([id_proveesftp] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [id_sftp_fk] FOREIGN KEY ([id_sftp_fk]) REFERENCES [sap].[SFtpProvedores] ([id_sftp])
);


GO

