CREATE TABLE [dbo].[ctlServidor] (
    [idServidor]  INT           IDENTITY (1, 1) NOT NULL,
    [descripcion] VARCHAR (150) NULL,
    [filtro]      INT           NULL,
    [ip]          VARCHAR (150) NULL,
    [estatus]     INT           NULL,
    CONSTRAINT [PK_ctlServidor] PRIMARY KEY CLUSTERED ([idServidor] ASC) WITH (FILLFACTOR = 90)
);


GO

