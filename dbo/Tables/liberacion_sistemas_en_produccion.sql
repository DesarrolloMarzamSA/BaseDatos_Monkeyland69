CREATE TABLE [dbo].[liberacion_sistemas_en_produccion] (
    [id_aplicacion]              INT            NOT NULL,
    [fecha_puesta_en_produccion] DATETIME       NULL,
    [libera]                     VARCHAR (50)   NULL,
    [recibe]                     VARCHAR (50)   NULL,
    [aplica]                     VARCHAR (50)   NULL,
    [vobo]                       VARCHAR (50)   NULL,
    [e_mail]                     VARCHAR (200)  NULL,
    [dispositivo]                VARCHAR (50)   NULL,
    [descripcion_del_cambio]     VARCHAR (1200) NULL,
    [afectacion]                 VARCHAR (500)  NULL,
    [proc_rollback]              VARCHAR (500)  NULL,
    [comentarios]                VARCHAR (1200) NULL,
    [selex]                      INT            NULL,
    PRIMARY KEY CLUSTERED ([id_aplicacion] ASC) WITH (FILLFACTOR = 90)
);


GO

