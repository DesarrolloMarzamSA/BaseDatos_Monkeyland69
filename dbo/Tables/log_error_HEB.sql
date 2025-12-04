CREATE TABLE [dbo].[log_error_HEB] (
    [advi_id]        INT            NOT NULL,
    [log_proceso]    VARCHAR (5000) NULL,
    [log_error]      VARCHAR (5000) NULL,
    [log_errorsql]   VARCHAR (5000) NULL,
    [log_procedure]  VARCHAR (5000) NULL,
    [log_fecha]      DATETIME       NULL,
    [log_lineaerror] INT            NULL
);


GO

