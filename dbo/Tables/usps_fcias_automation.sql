CREATE TABLE [dbo].[usps_fcias_automation] (
    [sucursal]      INT           NOT NULL,
    [interfase]     VARCHAR (50)  NOT NULL,
    [id]            VARCHAR (10)  NOT NULL,
    [usp]           VARCHAR (100) NOT NULL,
    [descripcion]   VARCHAR (200) NOT NULL,
    [orden]         INT           NOT NULL,
    [archivo]       VARCHAR (100) NOT NULL,
    [destino]       VARCHAR (100) NULL,
    [fecha_alta]    SMALLDATETIME NULL,
    [registros]     INT           NULL,
    [ult_ejecucion] SMALLDATETIME NULL,
    [habilitada]    INT           NULL,
    [corporativo]   BIT           NULL,
    [delimitador]   VARCHAR (5)   NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [interfase] ASC, [id] ASC) WITH (FILLFACTOR = 90)
);


GO

