CREATE TABLE [dbo].[TotalPeriodoAhorro] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [remision]         VARCHAR (12)    NULL,
    [totalIVA]         NUMERIC (18, 2) NULL,
    [totalRemision]    NUMERIC (18, 2) NULL,
    [totalRemisionIVA] NUMERIC (18, 2) NULL,
    [periodo]          INT             NULL,
    CONSTRAINT [PK_TotalPeriodoAhorro] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171121-165736]
    ON [dbo].[TotalPeriodoAhorro]([remision] ASC, [totalIVA] ASC, [totalRemision] ASC, [totalRemisionIVA] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171215-120429]
    ON [dbo].[TotalPeriodoAhorro]([remision] ASC, [periodo] ASC) WITH (FILLFACTOR = 90);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20171121-165722]
    ON [dbo].[TotalPeriodoAhorro]([remision] ASC, [periodo] ASC) WITH (FILLFACTOR = 90);


GO

