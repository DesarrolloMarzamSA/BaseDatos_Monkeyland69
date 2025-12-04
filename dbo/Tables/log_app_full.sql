CREATE TABLE [dbo].[log_app_full] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [PROCESO]     VARCHAR (50)  NULL,
    [FECHA_HORA]  DATETIME      NULL,
    [DESCRIPCION] VARCHAR (MAX) NULL
);


GO

