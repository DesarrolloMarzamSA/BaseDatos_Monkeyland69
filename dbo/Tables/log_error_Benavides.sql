CREATE TABLE [dbo].[log_error_Benavides] (
    [advi_id]        INT            IDENTITY (1, 1) NOT NULL,
    [log_proceso]    VARCHAR (5000) NULL,
    [log_error]      VARCHAR (5000) NULL,
    [log_errorsql]   VARCHAR (5000) NULL,
    [log_procedure]  VARCHAR (5000) NULL,
    [log_fecha]      DATETIME       CONSTRAINT [DF_LOG_ERROR_log_fecha2] DEFAULT (getdate()) NULL,
    [log_lineaerror] INT            NULL,
    CONSTRAINT [PK_log_error_Benavides] PRIMARY KEY CLUSTERED ([advi_id] ASC) WITH (FILLFACTOR = 90)
);


GO

