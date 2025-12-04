CREATE TABLE [dbo].[ftpprovedores] (
    [id_ftp]         INT              IDENTITY (1, 1) NOT NULL,
    [servidor]       NVARCHAR (30)    NULL,
    [usuario]        NVARCHAR (30)    NULL,
    [passwordd]      VARBINARY (8000) NULL,
    [carpeta]        NVARCHAR (100)   NULL,
    [puerto]         NVARCHAR (10)    NULL,
    [tiposervidor]   VARCHAR (10)     NULL,
    [usuarioreg]     NVARCHAR (10)    NULL,
    [NombreServidor] NVARCHAR (50)    NULL,
    CONSTRAINT [PK__ftpprove__D656F99B0E8400AF] PRIMARY KEY CLUSTERED ([id_ftp] ASC) WITH (FILLFACTOR = 90)
);


GO

