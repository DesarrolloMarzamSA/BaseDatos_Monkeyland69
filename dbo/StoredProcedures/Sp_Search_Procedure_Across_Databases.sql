Create Procedure Sp_Search_Procedure_Across_Databases
@ProcedureName nvarchar(Max)
As
BEGIN
DECLARE @SQL nvarchar(MAX)     --Declare variable to store dynamic query result
DECLARE @DB_NAME nvarchar(200) --Declare variable to store Database name
 
SET @SQL=''
 
--Create table to store the result of each database
CREATE TABLE #SearchResult
(
[DB_Name] nvarchar(max),
[Procedure Name] nvarchar(max),
[Status] varchar(50)
)
 
--Declare cusrsor to loop across all databases
DECLARE DB_Cursor CURSOR FOR
--Pick the list of all database
SELECT QUOTENAME([name]) from sys.databases order by [name]
 
OPEN DB_Cursor
FETCH NEXT FROM DB_Cursor INTO @DB_NAME
 
WHILE @@FETCH_STATUS = 0
BEGIN
--In this dynamic query, two select statements are built because
--one statement will check the unavailability and the
--second statement will check the availability of the
--procedure in the database and insert the result in the #SearchResult table
 
SET @SQL= 'Insert into #SearchResult
SELECT ''' + @DB_NAME + ''' as [Database Name],'''',''Not Available''
from ' + @DB_NAME + '. sys.procedures
Where [name] like ''%' + @ProcedureName + '%'' Having Count(*)=0
UNION ALL
SELECT ''' + @DB_NAME + ''' as [Database Name],[name],''Available''
from ' + @DB_NAME + '.sys.procedures
Where [name] like ''%' + @ProcedureName + '%'' Group By [name]
Having Count(*)>0'
 
EXEC(@SQL)
 
FETCH NEXT FROM DB_Cursor INTO @DB_NAME
END
CLOSE DB_Cursor
DEALLOCATE DB_Cursor
--We can browse the table to view the results
Select * from #SearchResult Order by [DB_Name],[Procedure Name]
END

GO

