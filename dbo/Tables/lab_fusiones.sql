CREATE TABLE [dbo].[lab_fusiones] (
    [id_lab]     VARCHAR (10)  NOT NULL,
    [lab_corto]  VARCHAR (6)   NOT NULL,
    [habilitado] BIT           DEFAULT ((1)) NULL,
    [registro]   SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([id_lab] ASC, [lab_corto] ASC)
);


GO

