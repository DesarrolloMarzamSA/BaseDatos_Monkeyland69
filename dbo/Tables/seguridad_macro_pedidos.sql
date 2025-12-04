CREATE TABLE [dbo].[seguridad_macro_pedidos] (
    [usuario]  VARCHAR (20) NOT NULL,
    [password] VARCHAR (20) NULL,
    [activo]   TINYINT      NULL,
    PRIMARY KEY CLUSTERED ([usuario] ASC)
);


GO

