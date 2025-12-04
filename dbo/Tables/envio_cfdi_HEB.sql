CREATE TABLE [dbo].[envio_cfdi_HEB] (
    [idenvioHeb]      INT           IDENTITY (1, 1) NOT NULL,
    [serie]           VARCHAR (10)  NOT NULL,
    [folio_fiscal]    VARCHAR (100) NOT NULL,
    [documentoIbs]    NUMERIC (18)  NOT NULL,
    [fechaEnvio]      DATETIME      NULL,
    [documentEstatus] VARCHAR (350) NULL,
    [codError]        VARCHAR (350) NULL,
    [msgError]        VARCHAR (350) NULL,
    [aperack]         VARCHAR (MAX) NULL,
    [estatusSistema]  INT           NULL,
    [tipoEnvio]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_cfdi_envio_HEB] PRIMARY KEY CLUSTERED ([idenvioHeb] ASC, [serie] ASC, [folio_fiscal] ASC, [documentoIbs] ASC)
);


GO

