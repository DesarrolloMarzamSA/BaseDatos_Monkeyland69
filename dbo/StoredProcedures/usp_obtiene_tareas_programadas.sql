USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_obtiene_tareas_programadas]
	@partime varchar(4) 
WITH ENCRYPTION
as
	declare @dw tinyint
	declare @mm tinyint

--declare @partime varchar(4)
--declare @dw tinyint
--declare @mm tinyint
--set @partime = '0714'
--set @partime = right(replicate('0', 2) + convert(varchar(2), datepart(hh, getdate())), 2) + right(replicate('0', 2) + convert(varchar(2), datepart(mi, getdate())), 2)

select 	@dw = datepart(dw, getdate() - 1)
select 	@mm = datepart(mm, getdate())

update	tareas_programadas 
set 		ejecutado = '0' 
where 	hora_ejecucion = @partime and
			substring(dias, @dw, 1) = '1' and
			substring(meses, @mm, 1) = '1' 
		
select	top 20 
			rtrim(path), 
			rtrim(ejecutable), 
			parametros,
			id_tarea_programada
from 		tareas_programadas
where	hora_ejecucion = @partime and
			substring(dias, @dw, 1) = '1' and
			substring(meses, @mm, 1) = '1' and
			habilitado = '1'
union
select	top 20 
			rtrim(path), 
			rtrim(ejecutable), 
			parametros,
			id_tarea_programada 
from 		tareas_programadas
where	demanda = '1' and
			habilitado = '1'
union
select	top 20 
			rtrim(path), 
			rtrim(ejecutable), 
			parametros,
			id_tarea_programada 
from		tareas_programadas
where	substring(dias, @dw, 1) = '1' and
			substring(meses, @mm, 1) = '1' and
			habilitado = '1' and
			datediff(mi, convert(datetime, hora_ultima_ejecucion, 121), getdate()) > 1440 and
			convert(int, hora_ejecucion) < convert(int, @partime)
union
select	top 20 
			rtrim(path), 
			rtrim(ejecutable), 
			parametros,
			id_tarea_programada 
from		tareas_programadas 
where	substring(dias, @dw, 1) = '1' and
			substring(meses, @mm, 1) = '1' and
			ejecutado = '0' and 
			habilitado = '1' and
			convert(int, hora_ejecucion) < convert(int, @partime)
GO
