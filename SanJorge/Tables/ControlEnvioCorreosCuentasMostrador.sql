CREATE TABLE [SanJorge].[ControlEnvioCorreosCuentasMostrador] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Cliente]     VARCHAR (10)  NOT NULL,
    [RutaArchivo] VARCHAR (200) NOT NULL,
    [Enviado]     BIT           NOT NULL,
    CONSTRAINT [PK_ControlEnvioCorreosCuentasMostrador] PRIMARY KEY CLUSTERED ([RutaArchivo] ASC)
);


GO

