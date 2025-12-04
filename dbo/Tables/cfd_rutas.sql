CREATE TABLE [dbo].[cfd_rutas] (
    [id_ruta]     INT           IDENTITY (1, 1) NOT NULL,
    [ruta]        VARCHAR (500) NOT NULL,
    [descripcion] VARCHAR (50)  NOT NULL,
    [orden]       INT           NULL,
    [habilitado]  BIT           NULL,
    [recursivo]   BIT           DEFAULT ((0)) NULL
);


GO

