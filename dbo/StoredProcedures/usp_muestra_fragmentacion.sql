
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_muestra_fragmentacion] @tabla as varchar(50)

as
 
DECLARE @TableName sysname
DECLARE cur_showfragmentation CURSOR FOR
SELECT table_name FROM information_schema.tables 
    WHERE table_name = @tabla
OPEN cur_showfragmentation
FETCH NEXT FROM cur_showfragmentation INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN 
  SELECT 'Show fragmentation for the ' + @TableName + ' table'
  DBCC SHOWCONTIG (@TableName)
  FETCH NEXT FROM cur_showfragmentation INTO @TableName
END
CLOSE cur_showfragmentation
DEALLOCATE cur_showfragmentation

GO
