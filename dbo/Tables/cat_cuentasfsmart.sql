CREATE TABLE [dbo].[cat_cuentasfsmart] (
    [sucursal]  TINYINT       NOT NULL,
    [letra]     VARCHAR (3)   NOT NULL,
    [cliente]   CHAR (10)     NOT NULL,
    [farmacia]  VARCHAR (50)  NULL,
    [poblacion] VARCHAR (50)  NULL,
    [activo]    INT           NULL,
    [timestamp] SMALLDATETIME NULL
);


GO

