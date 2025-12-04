CREATE TABLE [dbo].[EstadosFacturaPerfecta] (
    [Id]            TINYINT       IDENTITY (1, 1) NOT NULL,
    [Estado]        VARCHAR (50)  NOT NULL,
    [Descripcion]   VARCHAR (250) NOT NULL,
    [FechaRegistro] DATETIME      DEFAULT (getdate()) NULL,
    [BorradoLogico] BIT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tbl_EstadosFacturaPerfecta] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

