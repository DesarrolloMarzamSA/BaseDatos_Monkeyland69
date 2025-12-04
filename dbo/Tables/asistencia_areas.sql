CREATE TABLE [dbo].[asistencia_areas] (
    [sucursal]    TINYINT      NOT NULL,
    [areaidlo]    INT          NOT NULL,
    [descripcion] VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [areaidlo] ASC) WITH (FILLFACTOR = 90)
);


GO

