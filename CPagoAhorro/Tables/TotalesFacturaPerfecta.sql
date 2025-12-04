CREATE TABLE [CPagoAhorro].[TotalesFacturaPerfecta] (
    [Id]                            INT             IDENTITY (1, 1) NOT NULL,
    [Periodo]                       INT             NOT NULL,
    [Serie]                         VARCHAR (10)    NULL,
    [Estado]                        INT             NULL,
    [FechaPeriodo]                  DATETIME        DEFAULT (getdate()) NULL,
    [Rfc_receptor]                  VARCHAR (20)    NULL,
    [C42_Total_Bruto]               DECIMAL (20, 2) NULL,
    [C6_Total_neto]                 DECIMAL (20, 2) NULL,
    [C10_Tipo_iva]                  VARCHAR (10)    NULL,
    [C9_Total_impuestos]            DECIMAL (20, 2) NULL,
    [C13_Tasa_iva]                  DECIMAL (4, 2)  NULL,
    [C12_Base_Traslado]             DECIMAL (20, 2) NULL,
    [C14_Bruto_iva]                 DECIMAL (20, 2) NULL,
    [C25_Total_descuento_comercial] DECIMAL (20, 2) NULL,
    [C55_Tasa_IEPS1]                DECIMAL (20, 2) NULL,
    [C56_Importe_NETO_IEPS1]        DECIMAL (20, 2) NULL,
    [C57_Impuesto]                  VARCHAR (10)    NULL,
    [C59_Base]                      DECIMAL (20, 2) NULL,
    [C60_Tasa_IEPS2]                DECIMAL (20, 2) NULL,
    [C61_Importe_NETO_IEPS2]        DECIMAL (20, 2) NULL,
    [C62_Impuesto]                  VARCHAR (10)    NULL,
    [C64_Base]                      DECIMAL (20, 2) NULL,
    [C65_Tasa0]                     DECIMAL (4, 2)  NULL,
    [C66_Importe_Tasa0]             DECIMAL (20, 2) NULL,
    [C67_Impuesto]                  VARCHAR (10)    NULL,
    [C69_Base_Tasa0]                DECIMAL (20, 2) NULL,
    [FechaActualizacion]            DATETIME        CONSTRAINT [DF_TotalesFacturaPerfecta_FechaActualizacion] DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([Periodo] ASC)
);


GO

