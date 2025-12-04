CREATE TABLE [sap].[CargasInicialesNCRespaldo] (
    [idSeguimiento]    BIGINT          NULL,
    [Factura]          VARCHAR (20)    NULL,
    [FolioAgente]      VARCHAR (20)    NULL,
    [FolioDeCargo]     VARCHAR (20)    NULL,
    [Organizacion]     VARCHAR (20)    NULL,
    [CanalCdis]        VARCHAR (20)    NULL,
    [Sector]           VARCHAR (20)    NULL,
    [tipoDocumento]    VARCHAR (20)    NULL,
    [Solicitante]      VARCHAR (20)    NULL,
    [fechaDeCreacion]  VARCHAR (20)    NULL,
    [Motivo]           VARCHAR (20)    NULL,
    [Producto]         VARCHAR (20)    NULL,
    [Cantidad]         BIGINT          NULL,
    [Unidad]           VARCHAR (20)    NULL,
    [Precio]           DECIMAL (15, 2) NULL,
    [TotalDocumento]   DECIMAL (15, 2) NULL,
    [ImpuestoBase]     VARCHAR (20)    NULL,
    [Division]         VARCHAR (20)    NULL,
    [Centro]           VARCHAR (20)    NULL,
    [FechaRegistro]    VARCHAR (20)    NULL,
    [HoraRegistro]     VARCHAR (20)    NULL,
    [TipoNota]         VARCHAR (20)    NULL,
    [CarteraDocumento] VARCHAR (20)    NULL,
    [estatus]          BIGINT          NULL,
    [idref]            BIGINT          NULL,
    [detalleRef]       VARCHAR (200)   NULL,
    [apiWeb]           BIT             NULL
);


GO

