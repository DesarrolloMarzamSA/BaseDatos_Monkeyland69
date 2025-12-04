CREATE TABLE [dbo].[aplicaciones_monitorear] (
    [sucursal]    INT             NOT NULL,
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [segto]       VARCHAR (2)     NOT NULL,
    [ctepadre]    VARCHAR (3)     NOT NULL,
    [descripcion] VARCHAR (50)    NOT NULL,
    [horario0]    VARCHAR (8)     NOT NULL,
    [horario1]    VARCHAR (8)     NOT NULL,
    [facturas]    INT             NULL,
    [esperadas]   INT             NULL,
    [porc]        DECIMAL (10, 2) NULL,
    [color]       INT             NULL,
    [no_error]    VARCHAR (1500)  NULL,
    [consola]     BIT             NULL,
    [fecha_hora]  SMALLDATETIME   NULL,
    [ORDEN]       INT             NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [segto] ASC, [ctepadre] ASC) WITH (FILLFACTOR = 90)
);


GO

