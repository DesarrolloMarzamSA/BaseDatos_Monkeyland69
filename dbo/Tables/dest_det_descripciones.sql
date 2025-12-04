CREATE TABLE [dbo].[dest_det_descripciones] (
    [dest_det]    CHAR (3)     NOT NULL,
    [descripcion] VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([dest_det] ASC) WITH (FILLFACTOR = 90)
);


GO

