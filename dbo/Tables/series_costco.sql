CREATE TABLE [dbo].[series_costco] (
    [sucursal]    INT         NOT NULL,
    [consecutivo] VARCHAR (3) NOT NULL,
    CONSTRAINT [PK_series_costco] PRIMARY KEY CLUSTERED ([sucursal] ASC, [consecutivo] ASC)
);


GO

