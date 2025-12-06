USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_obtiene_tareas_programadasall]
	--@partime varchar(4) 
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

	
select	--top 20 
			rtrim(path), 
			rtrim(ejecutable), 
			parametros,
			id_tarea_programada
from 		tareas_programadas
where habilitado='1'
GO
