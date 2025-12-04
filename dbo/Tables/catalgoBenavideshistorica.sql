CREATE TABLE [dbo].[catalgoBenavideshistorica] (
    [IDIOMA]        CHAR (3)    NOT NULL,
    [CODIGO]        CHAR (7)    NOT NULL,
    [COD_PRODCLI]   CHAR (20)   NOT NULL,
    [fecha]         DATETIME    NOT NULL,
    [estatus]       VARCHAR (1) NOT NULL,
    [fechaRegistro] DATETIME    NULL
);


GO

