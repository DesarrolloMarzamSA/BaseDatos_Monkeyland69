CREATE TABLE [dbo].[bazar_direcciones_correo] (
    [sucursal]  TINYINT       NOT NULL,
    [cliente]   CHAR (5)      NOT NULL,
    [correo]    VARCHAR (100) NULL,
    [timestamp] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([sucursal] ASC, [cliente] ASC)
);


GO

