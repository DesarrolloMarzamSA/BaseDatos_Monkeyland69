CREATE TABLE [dbo].[cat_benavides_cod_rechazos] (
    [numero]      INT        NOT NULL,
    [layout]      CHAR (2)   NOT NULL,
    [descripcion] CHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([numero] ASC) WITH (FILLFACTOR = 90)
);


GO

