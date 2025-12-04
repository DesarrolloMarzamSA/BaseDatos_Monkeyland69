CREATE TABLE [dbo].[bazar_bonificaciones] (
    [segto]        CHAR (2) NOT NULL,
    [ctepadre]     CHAR (3) NOT NULL,
    [codigo]       CHAR (7) NOT NULL,
    [bonificacion] MONEY    NULL,
    [techo]        MONEY    NULL,
    [timestamp]    DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([segto] ASC, [ctepadre] ASC, [codigo] ASC) WITH (FILLFACTOR = 90)
);


GO

