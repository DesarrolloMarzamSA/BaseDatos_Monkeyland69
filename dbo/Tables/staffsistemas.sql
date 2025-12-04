CREATE TABLE [dbo].[staffsistemas] (
    [idstaff] INT          NOT NULL,
    [nombre]  VARCHAR (50) NULL,
    [alta]    DATETIME     NULL,
    [email]   VARCHAR (50) NULL,
    [area]    INT          NULL,
    [selex]   INT          NULL,
    CONSTRAINT [PK__staffsistemas__59063A47] PRIMARY KEY CLUSTERED ([idstaff] ASC) WITH (FILLFACTOR = 90)
);


GO

