CREATE TABLE [dbo].[temp_fbenavides_claudia] (
    [linea]        INT           IDENTITY (1, 1) NOT NULL,
    [solicitud]    SMALLDATETIME NULL,
    [sucursal]     INT           NOT NULL,
    [folio_fiscal] VARCHAR (10)  NOT NULL,
    [farmacia]     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [folio_fiscal] ASC) WITH (FILLFACTOR = 90)
);


GO

