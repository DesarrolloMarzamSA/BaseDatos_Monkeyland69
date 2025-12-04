CREATE TABLE [dbo].[historia] (
    [IP_ORIGEN]    VARCHAR (15)   NULL,
    [IP_DESTINO]   VARCHAR (15)   NULL,
    [RUTA_DESTINO] VARCHAR (30)   NULL,
    [USUARIO]      VARCHAR (15)   NOT NULL,
    [CODIGO]       INT            NOT NULL,
    [BASE]         TINYINT        NULL,
    [OFERTA]       TINYINT        NULL,
    [PORC]         NUMERIC (5, 2) NULL,
    [AJUSTE]       INT            NULL,
    [SEGM]         CHAR (15)      NOT NULL,
    [TIPO]         CHAR (1)       NULL,
    [NETO]         CHAR (1)       NULL,
    [FECHAINI]     CHAR (8)       NULL,
    [FECHATER]     CHAR (8)       NULL,
    [DESCRIPCION]  VARCHAR (30)   NULL,
    [FECHA_HORA]   DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([USUARIO] ASC, [CODIGO] ASC, [SEGM] ASC, [FECHA_HORA] ASC) WITH (FILLFACTOR = 90)
);


GO

