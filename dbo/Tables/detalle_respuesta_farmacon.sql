CREATE TABLE [dbo].[detalle_respuesta_farmacon] (
    [SUCURSAL]          INT             NOT NULL,
    [SERIE]             VARCHAR (10)    NOT NULL,
    [IDCUNO]            VARCHAR (11)    NOT NULL,
    [IDINVN]            NUMERIC (12)    NOT NULL,
    [IDLINE]            NUMERIC (5)     NOT NULL,
    [IDPRDC]            CHAR (35)       NOT NULL,
    [PCXPRC]            NUMERIC (13)    NULL,
    [IDDESC]            CHAR (50)       NOT NULL,
    [IDQTY]             NUMERIC (15, 3) NOT NULL,
    [FECHAPROG]         DATETIME2 (7)   NOT NULL,
    [IHOREF]            VARCHAR (35)    NOT NULL,
    [FECHACTUALIZACION] DATETIME        NULL,
    CONSTRAINT [PK_detalle_respuesta_farmacon] PRIMARY KEY CLUSTERED ([SUCURSAL] ASC, [SERIE] ASC, [IDINVN] ASC, [IDLINE] ASC, [IDPRDC] ASC, [IDQTY] ASC, [IHOREF] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [idx_detalle_respuesta_farmacon_IDINVN]
    ON [dbo].[detalle_respuesta_farmacon]([IDINVN] ASC);


GO

