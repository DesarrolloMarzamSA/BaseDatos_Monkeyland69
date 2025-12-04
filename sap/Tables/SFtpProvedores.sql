CREATE TABLE [sap].[SFtpProvedores] (
    [id_sftp]        INT              IDENTITY (1, 1) NOT NULL,
    [servidor]       NVARCHAR (30)    NULL,
    [usuario]        NVARCHAR (30)    NULL,
    [passwordd]      VARBINARY (8000) NULL,
    [carpeta]        NVARCHAR (100)   NULL,
    [puerto]         NVARCHAR (10)    NULL,
    [tiposervidor]   VARCHAR (10)     NULL,
    [usuarioreg]     NVARCHAR (10)    NULL,
    [NombreServidor] NVARCHAR (50)    NULL,
    CONSTRAINT [pk_SFtpproveedores] PRIMARY KEY CLUSTERED ([id_sftp] ASC) WITH (FILLFACTOR = 90)
);


GO

