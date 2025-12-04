CREATE TABLE [sap].[ControlEnvioCINC] (
    [idSeg]      BIGINT       NOT NULL,
    [estatus]    BIGINT       NOT NULL,
    [apiWeb]     BIT          NOT NULL,
    [feRegistro] VARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([idSeg] ASC)
);


GO

