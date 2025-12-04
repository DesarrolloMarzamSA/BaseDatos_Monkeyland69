CREATE TABLE [dbo].[archivos] (
    [nombre_archivo]  VARCHAR (250) NULL,
    [md5]             NVARCHAR (50) NOT NULL,
    [horno]           VARCHAR (50)  NULL,
    [fecha_insercion] DATETIME      CONSTRAINT [DF_archivos_fecha_insercion] DEFAULT (getdate()) NOT NULL,
    [serie_hand_held] INT           IDENTITY (1, 1) NOT NULL,
    [estado]          INT           CONSTRAINT [DF_archivos_estado] DEFAULT ((0)) NOT NULL,
    [numero_factura]  VARCHAR (50)  CONSTRAINT [DF_archivos_numero_factura] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_archivos_1] PRIMARY KEY CLUSTERED ([md5] ASC) WITH (FILLFACTOR = 90)
);


GO

