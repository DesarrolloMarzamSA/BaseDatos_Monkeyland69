CREATE TABLE [dbo].[ClientesWalmart] (
    [Determinante]  INT           NOT NULL,
    [CuentaCliente] VARCHAR (20)  NOT NULL,
    [Sucursal]      VARCHAR (10)  NULL,
    [Formato]       VARCHAR (50)  NULL,
    [NombreTienda]  VARCHAR (200) NULL,
    [DigitoFormato] INT           NULL,
    [GLNProveedor]  BIGINT        NOT NULL,
    [GLNWalmart]    BIGINT        NOT NULL,
    [GLNTienda]     BIGINT        NOT NULL
);


GO

