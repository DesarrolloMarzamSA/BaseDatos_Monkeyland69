CREATE TABLE [dbo].[parametros_centinela_comunicaciones] (
    [ip]            VARCHAR (50)  NOT NULL,
    [usuario]       VARCHAR (30)  NULL,
    [password]      VARCHAR (30)  NULL,
    [ruta]          VARCHAR (50)  NULL,
    [leyenda_error] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ip] ASC) WITH (FILLFACTOR = 90)
);


GO

