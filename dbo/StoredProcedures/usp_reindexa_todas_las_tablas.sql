USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_reindexa_todas_las_tablas]
WITH ENCRYPTION
as
declare @tabla varchar(255)
declare cursor_tablas cursor fast_forward for select name from sysobjects where xtype = 'U'
open cursor_tablas
fetch next from cursor_tablas into @tabla
while @@fetch_status = 0
begin
	exec usp_reindexa_tabla @tabla
	fetch next from cursor_tablas into @tabla
end
close cursor_tablas
deallocate cursor_tablas
GO
