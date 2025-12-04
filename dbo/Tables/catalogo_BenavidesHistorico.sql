CREATE TABLE [dbo].[catalogo_BenavidesHistorico] (
    [PRODUCTO]              VARCHAR (50)  NOT NULL,
    [P_FARMACIA]            FLOAT (53)    NULL,
    [OFERTA]                FLOAT (53)    NULL,
    [COMERCIAL]             FLOAT (53)    NULL,
    [CONFIDENCIAL]          FLOAT (53)    NULL,
    [CADENA]                FLOAT (53)    NULL,
    [P_FINAL_SIN_IMPUESTOS] FLOAT (53)    NOT NULL,
    [P_PUBLICO]             FLOAT (53)    NULL,
    [DESDE]                 VARCHAR (255) NULL,
    [HASTA]                 VARCHAR (255) NULL,
    [TIPO]                  VARCHAR (255) NULL,
    [CANT_BASE]             FLOAT (53)    NULL,
    [CANT_OFERTA]           FLOAT (53)    NULL,
    [SUCURSAL]              VARCHAR (255) NULL,
    [EX_SUCURSAL]           VARCHAR (255) NULL,
    [IMMOVC]                VARCHAR (255) NULL,
    [IMVOLC]                VARCHAR (255) NULL,
    [PGPDGR]                VARCHAR (255) NULL,
    [PGPPGR]                VARCHAR (255) NULL,
    [PGPGRP]                VARCHAR (255) NULL,
    [PGAGRP]                VARCHAR (255) NULL,
    [PGPCA1]                VARCHAR (255) NULL,
    [PGPCA2]                VARCHAR (255) NULL,
    [PGPCA3]                VARCHAR (255) NULL,
    [PGPCA4]                VARCHAR (255) NULL,
    [PGPCA5]                VARCHAR (255) NULL,
    [PGPCA6]                VARCHAR (255) NULL,
    [PGPRFA]                VARCHAR (255) NULL,
    [PGPRSE]                VARCHAR (255) NULL,
    [PGDESC]                VARCHAR (255) NULL,
    [MSMDEC]                VARCHAR (255) NULL,
    [EX_TOTAL]              FLOAT (53)    NULL,
    [PXTX50]                VARCHAR (255) NULL,
    [PJEANP]                VARCHAR (255) NULL,
    [CTPCT1]                VARCHAR (255) NULL,
    [CTPCT2]                VARCHAR (255) NULL,
    [CTPCT6]                VARCHAR (255) NULL,
    [DEVOLUCION]            VARCHAR (255) NULL,
    [DEV_DIAS_ANTES]        VARCHAR (255) NULL,
    [DEV_DIAS_DESPUES]      VARCHAR (255) NULL,
    [IVA]                   FLOAT (53)    NULL,
    [IEPS]                  FLOAT (53)    NULL,
    [PJPTQT]                FLOAT (53)    NULL,
    [PGCDAT]                FLOAT (53)    NULL,
    [PGPHNCAT]              VARCHAR (255) NULL,
    [PGPHISPC]              VARCHAR (255) NULL,
    [PGPHCOOL]              VARCHAR (255) NULL,
    [NANSNA]                VARCHAR (255) NULL,
    [HASHCODE]              BIGINT        NOT NULL,
    [FECHAACTUALIZACION]    DATETIME      NULL
);


GO

CREATE CLUSTERED INDEX [ClusteredIndex-20171024-152321]
    ON [dbo].[catalogo_BenavidesHistorico]([PRODUCTO] ASC, [P_FARMACIA] ASC, [HASHCODE] ASC) WITH (FILLFACTOR = 90);


GO

