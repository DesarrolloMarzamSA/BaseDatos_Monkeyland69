CREATE TABLE [dbo].[tareas_programadas_respaldo] (
    [id_tarea_programada]   CHAR (10)      NOT NULL,
    [sucursal]              TINYINT        NULL,
    [path]                  NVARCHAR (200) NULL,
    [ejecutable]            NVARCHAR (150) NULL,
    [descripcion]           NVARCHAR (150) NULL,
    [hora_ejecucion]        NVARCHAR (150) NULL,
    [parametros]            NVARCHAR (150) NULL,
    [dias]                  CHAR (7)       NULL,
    [meses]                 CHAR (12)      NULL,
    [ejecutado]             CHAR (2)       NULL,
    [demanda]               CHAR (2)       NULL,
    [habilitado]            CHAR (2)       NULL,
    [hora_ultima_ejecucion] DATETIME       NULL,
    [selex]                 INT            NULL,
    [observaciones]         VARCHAR (400)  NULL,
    [propietario]           CHAR (5)       NULL,
    [clase]                 VARCHAR (3)    NULL,
    [fecha_creacion]        DATE           NULL,
    [tipo]                  VARCHAR (10)   NULL
);


GO

