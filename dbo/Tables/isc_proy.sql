CREATE TABLE [dbo].[isc_proy] (
    [idproyecto]  INT           NOT NULL,
    [proyecto]    VARCHAR (50)  NULL,
    [archivo_asp] VARCHAR (100) NULL,
    [orden]       INT           NULL,
    [habilitada]  INT           NULL,
    [selex]       INT           NULL,
    PRIMARY KEY CLUSTERED ([idproyecto] ASC) WITH (FILLFACTOR = 90)
);


GO

