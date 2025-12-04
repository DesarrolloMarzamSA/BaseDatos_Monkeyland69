CREATE TABLE [dbo].[cattemp2] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [criterio]     SMALLINT       NOT NULL,
    [cliente]      NVARCHAR (MAX) NOT NULL,
    [plantilla]    XML            NOT NULL,
    [nombre]       NVARCHAR (100) NOT NULL,
    [tipo]         NVARCHAR (50)  NOT NULL,
    [archivo]      NVARCHAR (100) NOT NULL,
    [activo]       NCHAR (1)      NOT NULL,
    [ruta]         NVARCHAR (512) NULL,
    [email]        NVARCHAR (512) NULL,
    [ftp]          NVARCHAR (512) NULL,
    [usuario]      NVARCHAR (512) NULL,
    [password]     NVARCHAR (512) NULL,
    [lun]          NCHAR (1)      NOT NULL,
    [mar]          NCHAR (1)      NOT NULL,
    [mie]          NCHAR (1)      NOT NULL,
    [jue]          NCHAR (1)      NOT NULL,
    [vie]          NCHAR (1)      NOT NULL,
    [sab]          NCHAR (1)      NOT NULL,
    [dom]          NCHAR (1)      NOT NULL,
    [hora]         NCHAR (4)      NOT NULL,
    [condicion]    NVARCHAR (MAX) NULL,
    [codificacion] NVARCHAR (25)  NULL,
    [protocolo]    NVARCHAR (5)   NULL,
    [puerto]       SMALLINT       NULL,
    [grupo]        NVARCHAR (100) NULL
);


GO

