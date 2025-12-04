CREATE TABLE [dbo].[uuid_facturacion] (
    [ID_FACTURA]  INT          IDENTITY (1, 1) NOT NULL,
    [CEINVN]      NUMERIC (12) NOT NULL,
    [CECSTS]      CHAR (5)     NOT NULL,
    [CESERI]      CHAR (10)    NOT NULL,
    [CEFECH]      NUMERIC (30) NOT NULL,
    [CEDENO]      CHAR (15)    NOT NULL,
    [CEUUID]      CHAR (50)    NOT NULL,
    [FECHAACTUAL] DATETIME     CONSTRAINT [DF_uuid_facturacion_FECHAACTUAL] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_uuid_facturacion] PRIMARY KEY CLUSTERED ([ID_FACTURA] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190701-165542]
    ON [dbo].[uuid_facturacion]([CEINVN] ASC, [CECSTS] ASC, [CESERI] ASC, [CEDENO] ASC);


GO

