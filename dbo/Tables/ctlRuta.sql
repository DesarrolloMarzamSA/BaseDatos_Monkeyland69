CREATE TABLE [dbo].[ctlRuta] (
    [idruta]      INT           IDENTITY (1, 1) NOT NULL,
    [ruta]        VARCHAR (500) NULL,
    [descripcion] VARCHAR (150) NULL,
    [idServidor]  INT           NULL,
    [estatus]     INT           NULL,
    CONSTRAINT [PK_ctlRutas] PRIMARY KEY CLUSTERED ([idruta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ctlRutas_ctlServidor] FOREIGN KEY ([idServidor]) REFERENCES [dbo].[ctlServidor] ([idServidor])
);


GO

