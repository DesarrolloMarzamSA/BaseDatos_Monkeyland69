CREATE TABLE [dbo].[pedidos_rama] (
    [identificador]      CHAR (10)      NOT NULL,
    [consecutivo]        BIGINT         NOT NULL,
    [cliente]            VARCHAR (5)    NULL,
    [digito]             CHAR (1)       NULL,
    [procesado]          CHAR (1)       CONSTRAINT [DF_pedidos_rama_procesado] DEFAULT ('0') NULL,
    [codigo]             VARCHAR (7)    NOT NULL,
    [codigopresentacion] CHAR (10)      NOT NULL,
    [cant_ped]           INT            NULL,
    [cant_surt]          INT            CONSTRAINT [DF_pedidos_rama_cantidadsurtida] DEFAULT (0) NULL,
    [digitocausa]        CHAR (1)       CONSTRAINT [DF_pedidos_rama_digitocausa] DEFAULT ('7') NULL,
    [precio]             CHAR (10)      CONSTRAINT [DF_pedidos_rama_precio] DEFAULT ('0000000000') NULL,
    [piezassincargo]     CHAR (4)       CONSTRAINT [DF_pedidos_rama_piezassincargo] DEFAULT ('0000') NULL,
    [rutaarchivo]        NVARCHAR (400) NULL,
    [hashmd5]            NVARCHAR (50)  NULL,
    [fecha]              DATETIME       NOT NULL,
    [encontrado]         CHAR (1)       CONSTRAINT [DF_pedidos_rama_encontrado] DEFAULT ('0') NULL,
    [forzado]            CHAR (1)       NULL,
    CONSTRAINT [PK_pedidos_rama] PRIMARY KEY CLUSTERED ([identificador] ASC, [consecutivo] ASC, [codigo] ASC, [codigopresentacion] ASC, [fecha] ASC) WITH (FILLFACTOR = 90)
);


GO

