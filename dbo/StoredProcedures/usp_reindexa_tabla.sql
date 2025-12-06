
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_reindexa_tabla] @tabla varchar(100)
WITH ENCRYPTION
as
DECLARE @TableName sysname
DECLARE @indid int
DECLARE cur_tblfetch CURSOR fast_forward FOR
SELECT table_name FROM information_schema.tables WHERE table_type = 'base table' and table_name = @tabla
OPEN cur_tblfetch
FETCH NEXT FROM cur_tblfetch INTO @TableName
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE cur_indfetch CURSOR fast_forward FOR
SELECT indid FROM sysindexes WHERE id = OBJECT_ID (@TableName) and keycnt > 0
OPEN cur_indfetch
FETCH NEXT FROM cur_indfetch INTO @indid
WHILE @@FETCH_STATUS = 0
BEGIN
  SELECT 'Derfagmenting index_id = ' + convert(char(3), @indid) + 'of the '
          + rtrim(@TableName) + ' table'
  IF @indid <> 255 DBCC INDEXDEFRAG (monkeyland, @TableName, @indid)
  FETCH NEXT FROM cur_indfetch INTO @indid
END
CLOSE cur_indfetch
DEALLOCATE cur_indfetch
  FETCH NEXT FROM cur_tblfetch INTO @TableName
END
CLOSE cur_tblfetch
DEALLOCATE cur_tblfetch
GO
