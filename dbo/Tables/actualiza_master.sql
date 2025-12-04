CREATE TABLE [dbo].[actualiza_master] (
    [table_name]            NVARCHAR (15)  NULL,
    [delete_before]         BIT            NULL,
    [incremental_key_field] NVARCHAR (15)  NULL,
    [condition]             NVARCHAR (500) NULL,
    [last_value]            BIGINT         NULL,
    [last_update]           SMALLDATETIME  NULL,
    [once_a_day]            BIT            NULL
);


GO

